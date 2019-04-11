# Card Tracker

A Magic: The Gathering inventory/collection tracker.

## Ruby Version

2.6.2

## Rails Version

5.2.3

## Dependencies

* [vips](https://jcupitt.github.io/libvips/)

## Local Development Installation

Clone the repository.

    $ git clone git@github.com:seaneshbaugh/card_tracker.git card_tracker

cd into the project directory.

    $ cd card_tracker

Start the Docker containers.

    $ docker-compose up -d --build

Create the development and test databases.

    $ docker-compose run web rails db:create

Load the database schema.

    $ docker-compose run web rails db:schema:load

Seed the database.

    $ docker-compose run web rails db:seed

## Troubleshooting

#### `Node Sass could not find a binding for your current environment: Linux 64-bit with Node.js 11.x`

If you update `/package.json` and run `yarn install` on the host machine it will overwrite the contents of `/node_modules` and in the process will rebuild Node Sass for the host machine. If the host machine is not the same OS as the Docker container you will see this error. This can be fixed by running `docker-compose run -rm web yarn install --force` and then restarting the `web` container.

#### `no space left on device`

This happens from time to time. Dead containers and unused images can be cleaned up with:

    $ docker ps --filter status=dead --filter status=exited -aq | xargs docker rm -v
    $ docker images --no-trunc | grep '<none>' | awk '{ print $3 }' | xargs docker rmi

## Deploying

More on this later!

## Linting

### Ruby

    $ rubocop

### HAML

    $ haml-lint

### SCSS

    $ yarn run sass-lint --verbose --no-exit --config .sass-lint.yml

## Contacts

* [Sean Eshbaugh](mailto:seaneshbaugh@gmail.com)
