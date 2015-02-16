# Docker and NodeJS - quick start

Welcome.

**This is a quick start guide for creating a Docker container that runs a NodeJS web server. We’ll look at a basic development workflow to manage the local development of an app, on Mac OS X, as well as continuous integration and delivery, step by step.**

ADD IMAGE

> This tutorial is ported from [Docker in Action - Fitter, Happier, More Productive](https://realpython.com/blog/python/docker-in-action-fitter-happier-more-productive/).

## Docker?

Be sure you understand the Docker basics before diving into this tutorial. Check out the offical ["What is Docker?"](https://www.docker.com/whatisdocker/) guide for an excellent intro.

**In short**:

With Docker, you can truly mimic your production environment on your local machine. No more having to debug environment specific bugs or worrying that your app will perform differently in production.

1. Version control for infrastructure
1. Easily distrubute/recreate your entire development environment
1. Build once, run anywhere – aka The Holy Grail!

**Some Docker-specific terms**:

- A *Dockerfile is a file that contains a set of instructions used to create an *image*.
- An *image* is used to build and save snapshots (the state) of an environment.
- A *container* is an instantiated, live *image* that runs a collection of processes.

> Be sure to check out the Docker [documentation](https://docs.docker.com/) for more info on [Dockerfiles](https://docs.docker.com/reference/builder/), [images](https://docs.docker.com/terms/image/), and [containers](https://docs.docker.com/terms/container/).

## Local Setup

Let's get your local development enviornment set up!

### Get Docker

Follow the download instructions from the guide [Installing Docker on Mac OS X](https://docs.docker.com/installation/mac/) to install both Docker and the official boot2docker package. [boot2docker](http://boot2docker.io/) is a *lightweight* Linux distribution designed specifically to run Docker for Windows and Mac OS X users. In essence, it starts a small VM that’s configured to run Docker containers.

Once installed, run the following commands in your project directory to start boot2docker:

```sh
$ boot2docker init
$ boot2docker up
$ $(boot2docker shellinit)
```

### Fig Up!

[Fig](http://www.fig.sh/) is an orchestration framework that handles the building and running of multiple services, which makes it easy to link multiple services together running in different containers. Follow the installation instructions [here](http://www.fig.sh/install.html), and then test it out to make sure all is well:

```sh
$ fig --version
fig 1.0.1
```

### Get the Project

Grab the base code from the [repo](https://github.com/mjhea0/node-docker-workflow/releases/tag/base), and add it to your project directory:

```sh
├── Dockerfile
├── app
│   ├── index.js
│   ├── package.json
│   └── test
│       └── test.js
├── fig.yml
└── requirements.txt
```

**fig.yml**:

```
web:
  build: .
  volumes:
    - "app:/src/app"
  ports:
    - "80:3000"
  links:
   - redis
redis:
    image: redis:2.8.19
    ports:
        - "6379:6379"
```

Here we add the services that make up our basic stack:

1. **web**: First, we build the image based on the instructions in the *Dockerfile* - where we setup our Node environment, create a volume, install the required dependencies, and fire up the app running on port 3000. Then we forward that port in the conatiner to port 80 on the host environment - e.g., the boot2docker VM.
1. **redis**: Next, the Redis service is built from the Docker Hub "Redis" [image](https://registry.hub.docker.com/_/redis/) (more on this later). Port 6379 is exposed and forwarded.

### Profit

Run `fig up` to build a new image for the Express app, pull the Redis image from Docker Hub, and then run both processes in new containers. Open your browser and naviage to the boot2docker IP address (`boot2docker ip`). You should see the text, "You have viewed this page 1 times!" in your browser. Refresh. The page counter should increment.

Once done, kill the processes (Ctrl-C). Commit your changes locally, and then push to Github.

### Next Steps

So, what did we accomplish?

We set up our local environment, detailing the basic process of building an *image* from a *Dockerfile* and then creating an instance of the image called a *container*. We then tied everything together with fig to build and connect different containers for both the Express app and Redis process.

Next, let’s talk about Continuous Integration...

## Continuous Integration

...starting with Docker Hub...

### Docker Hub

[Docker Hub](https://hub.docker.com/) "manages the lifecycle of distributed apps with cloud services for building and sharing containers and automating workflows". It's the Github for Docker images.

1. [Signup](https://hub.docker.com/account/signup/) using your Github credentials.
1. [Set up](http://docs.docker.com/docker-hub/builds/#about-automated-builds) a new automated build. And add your Github repo that you created and pushed to earlier. Just accept all the default options. Once added, Docker Hub will trigger an initial build.

Each time you push to Github, Docker Hub will generate a new build from scratch.

Docker Hub acts much like a continuous integration server since it ensures you do not cause a regression that completely breaks the build process when the code base is updated.

That said, let's use a *true* continuous integration server - [CircleCI](https://circleci.com/).

### CircleCI

[CircleCI](https://circleci.com/) is a CI platform that supports Docker.

Given a Dockerfile, CircleCI builds an image, starts a new container (or containers), and then runs tests inside that container.

1. Sign up with your Github account.
1. Create a new project using the Github repo you created.

Next we need to add a configuration file, called *circle.yml*, to the root folder of the project so that CircleCI can properly create the build.

```
machine:
  services:
    - docker

dependencies:
  override:
    - pip install -r requirements.txt

test:
  override:
    - fig run -d --no-deps web
    - cd app; mocha
```

Here, we install the dependecies via [pip](http://en.wikipedia.org/wiki/Pip_%28package_manager%29), then we create a new image, run the container, and run our unit tests.

> Notice how we’re using the command `fig run -d --no-deps web`, to run the web process, instead of `fig up`. This is because CircleCI already has Redis [running](https://circleci.com/docs/environment#databases) and available to us for our tests. So, we just need to run the web process.

Before we test this out, we need to change some settings on Docker Hub.

### Docker Hub (redux)

Right now, each push to Github will create a new build. That's not what we want. Instead, we CircleCI to run tests against the master branch then *after* they pass, a new build should trigger on Docker Hub.

Open your repository on Docker Hub, and make the following updates:

1. Under *Settings* click *Automated Build*.
1. Uncheck the Active box: “When active we will build when new pushes occur”. Save the changes.
1. Then once again under *Settings* click *Build Triggers*.
1. Change the status to on.
1. Copy the example curl command – i.e., `$ curl --data "build=true" -X POST https://registry.hub.docker.com/u/mjhea0/node-docker-workflow/trigger/84957124-2b85-410d-b602-b48193853b66/`.

### CircleCI (redux)

Back on CircleCI, let's add that curl command as an environment varible:

1. Within the *Project Settings*, select *Environment variables*.
1. Add a new variable with the name "DEPLOY" and paste the curl command as the value.

Then add the following code to the bottom of the *circle.yml* file:

```
deployment:
  hub:
    branch: master
    commands:
      - $DEPLOY
```

This simple fires the `$DEPLOY` variable after tests pass on the master branch.

Now, let's test!

## Profit!

Follow these steps...

1. Create a new branch
1. Make changes locally
1. Issue a pull request
1. Manually merge once the tests pass
1. Once the second round passes, a new build is triggered on Docker Hub

What's left?
