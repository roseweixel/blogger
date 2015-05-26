# Flatiron Blog App

Rails app that streamlines the student blogging process at Flatiron School.

## Description

* Allows instructors to generate and keep track of blogging schedules
* Sends notifications and reminders to students
* Provides easy access to all the student blogs in a central location
* Gives students green lights for completing their posts on time
* Allows staff to publish student posts directly to the Flatiron School WordPress blog

### Getting Started

1. `git clone git@github.com:flatiron-labs/flatiron-blog-app.git` 
2. `cd flatiron-blog-app`
3. `bundle install`
4. `figaro install` (creates `config/application.yml` and adds it to `.gitignore` for hiding sensitive information)
5. Get credentials for Sendgrid, Github, and WordPress (talk to Rose Weixel - rose@flatironschool.com), and add these credentials to `config/application.yml`:
```
sendgrid_username: <credential goes here>
sendgrid_password: <credential goes here>

github_client_id: <credential goes here>
github_client_secret: <credential goes here>

wordpress_client_secret: <credential goes here>
wordpress_client_id: <credential goes here>
```
