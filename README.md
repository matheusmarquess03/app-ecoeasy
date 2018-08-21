# Eco Clean Technical Information

| Summary                                                                                          |
|--------------------------------------------------------------------------------------------------|
| [Getting Started](#getting-started-go-to-summary)                                                |
| [Deployment And Running  Instructions](#deployment-and-running-instructions-go-to-summary)       |                                                 |


## Getting Started - [go to summary](#eco-clean-technical-information)


## Deployment And Running Instructions - [go to summary](#eco-clean-technical-information)
This session is intended to list whatever steps are necessary to get the application up and running.
Besides that, here you'll find some technical informations like versions and jobs to be executed.

* Ruby Version `2.4.2`
* Rails Version `5.2.1`
* Database `PostgreSQL`
* Rails Server `Puma`
* Running the application for the first time
  * First, after cloning and accessing the project directory run `bundle` command to install the gems
  * Then, open the `config/application.yml` file and verify if the connection information for the
   database is correct (`DATABASE_NAME`, `DATABASE_USER`, `DATABASE_PASSWORD`, `DATABASE_HOST`) for
   the environments you want to run (`development`, `test`, `staging`, `production`);
  * Then, run the commands to create, migrate and seed the database according to the wanted environment:
      * `RAILS_ENV=development rails db:create db:migrate db:seed`
      * `RAILS_ENV=test rails db:create db:migrate db:seed`
      * `RAILS_ENV=staging rails db:create db:migrate db:seed`
      * `RAILS_ENV=production rails db:create db:migrate db:seed`
  * Finally, just run the application according to the wanted environment:
      * `rails start` for development environment
      * `rails start -e test` for development test
      * `rails start -e staging` for development staging
      * `rails start -e production` for development production
* Deployment instructions
  * If the project is already running on the server you just need to commit on `staging` branch to
  deploy on staging or commit on `production` branch to deploy on production.

