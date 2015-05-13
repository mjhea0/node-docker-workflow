![docker logo](images/docker-logo.jpg)

### Fitter. Happier. More Productive.

<hr>

Presented at the [NodeJS Denver/Boulder](http://www.meetup.com/Node-js-Denver-Boulder/)<br> Meetup group on March 5th, 2015.

---

## Joke

<hr><br>

### What did the hippie say when asked to get off the couch?

----

Namaste<br>(nah-I'm-a-stay)

---

## About Me

<hr>

- Full-stack web developer
- Co-founder/Author of [Real Python](https://realpython.com) - specializes in teaching the Python syntax and web development.

    ![real python logo](images/rp_logo_color_small.png)

- Mentor/educator/teacher/blogger - [refactorU](http://www.refactoru.com/)
- Bottom-line: *I don't sleep*.

---

## Today

<hr>

1. Docker basics (~10%)
1. Development workflow (~90%) - Docker setup, local development, continous integration/delivery

Note: We're covering a lot of material today. Don't worry if you miss something or don't fully understand a concept since this entire workflow will be featured in a blog post on Real Python - https://realpython.com. The post will go live on 02/10/2015. I would recommend just watching me go through the workflow, and then recreate it on your own next week when the post goes live.

---

## What is Docker?

<hr><br>

#### Containers AND Images AND Dockerfiles. Oh my!

![oh my](images/oh-my.jpg)

Note:
With Docker you can easily deploy a web application along with the app's dependencies, environment variables, and configuration settings - everything you need to recreate your environment quickly and efficiently.
- A *Dockerfile* is a file that contains a set of instructions used to create an *image*.
- An *image* is used to build and save snapshots (the state) of an environment.
- A *container* is an instantiated, live *image* that runs a collection of processes.

----

## Why Docker?

<hr>

1. Version control for infrastructure
1. Easily distribute/recreate your entire dev env
1. Build once, run anywhere - aka The Holy Grail!

![holy grail](images/holy-grail.jpg)

Note: In other words, you can truly mimic your production environment on your local machine. No more having to debug environment specific bugs or worrying that your app will perfrom different in production.

---

## Workflow!

<hr><br>

![steps](images/steps.jpg)

Note:
1. Code locally on a feature branch
1. Open a pull request on Github against the master branch
1. Run automated tests against the Docker container
1. If the tests pass, manually merge the pull request into master
1. Once merged, the automated tests run again
1. If the second round of tests pass, a build is created on Docker Hub
1. Once the build is created, it's then automatically (err, automagically) deployed to production

---

# Part 1 - Local Setup

----

## Docker Setup

<hr>

Let's get Docker up and running!

<br>

Enter **Boot2Docker** - a *lightweigh*t Linux distribution designed specifically to run Docker ([Install](https://docs.docker.com/installation/mac/))

----

## Compose Up!

<hr>

![docker compose](images/compose.png)

- **[Docker Compose](https://github.com/docker/compose)** builds and runs services needed for your application's tech stack.
- Install and then define the services within a *docker-compose.yml* file.

----

## Build and Run

<hr><br>

### `$ docker-compose up`

![fig logo](images/figup.png)

---

# Part 2 - Continuous Integration

----

## Docker Hub

<hr>

- [Docker Hub](https://hub.docker.com/) is a repository of Docker images.
- It acts as a CI server since you can configure it to create a build every time you push a new commit to Github.

----

## CircleCI

<hr>

![circleci logo](images/circleci.png)

- **[CircleCI](https://circleci.com/)** is a continuous integration and delivery platform that supports testing within Docker containers.
- [Getting started with CircleCI](https://circleci.com/docs/getting-started) - super simple setup
- Add a *circle.yml* config file

----

## Feature Branch Workflow

<hr>

Example...

1. Create the branch
1. Make changes locally
1. Issue a Pull request
1. Manually merge once the tests pass
1. The tests run again on the master branch
1. Once the second round passes, a new build is triggered on Docker Hub

---

# Part 3 - Continuous Delivery

----

## Tutum

<hr>

![tutum logo](images/tutum.jpg)

- [Tutum](https://www.tutum.co/) manages the orchestration and deployment of Docker images and containers.
- This service is used for the actual delivery of our app to Digital Ocean.

----

## Tutum (setup)

<hr>

1. Sign up
1. Link your Digital Ocean Account
1. Add a Node
1. Add a stack
1. Add web hook
1. Profit

----

## Feature Branch Workflow (redux)

<hr>

1. Create the branch
1. Make changes locally
1. Issue a Pull request
1. Manually merge once the tests pass
1. The tests run again on the master branch
1. Once the second round passes, a new build is triggered on Docker Hub
1. After the build is triggered, a post request is sent to Tutum, which redeploys the app.

---


# Conclusion

<hr>

- So, we went over a nice development workflow that included setting up a local environment coupled with continuous integration.
- **michael@realpython.com**

<br>

Cheers!

---
