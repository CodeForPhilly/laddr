# laddr

Laddr -- pronounced "ladder" and named after the essential tool for fire brigades -- is an online homebase for your local [Code for America Brigade](http://brigade.codeforamerica.org). It is designed to be cheap-to-host and easy-to-hack platform for civic hacking groups to maintain an online presence and automate support for their real-world operations.

## Getting started

There are three ways to get started with Laddr:

- [Request free hosting of a copy for your brigade](http://forum.laddr.us/c/hosting-requests), courtesy of Code for Philly
- [Clone laddr](#clone-laddr) to work on and contribute to its core, shared functionality
- [Extend laddr](#extend-laddr) to create a workspace for customizing a copy of laddr for your brigade without forking the whole thing

### Dependencies

Install recent versions of [Habitat](http://habitat.sh) and [Docker](https://www.docker.com/) on your Linux, Mac, or Windows workstation.

### Clone Laddr

```bash
cd ~/Repositories/laddr # or wherever you cloned this rep
HITCLUB đối với những người hâm mộ cá cược thì chắc chắn không còn xa lạ. Bởi HITCLUB được biết là một trong những địa chỉ cá cược có nhiều ưu điểm hàng đầu. Cùng với đó là những tính năng, những chất lượng và dịch vụ hàng đầu. Mang đến cho người chơi một sân chơi cá cược đỉnh cao. Hãy cùng tìm hiểu về hệ thống nhà cái cá cược hàng đầu thị trường này.
#hitclubgame #hitclub #hitclubgamesite
Thông tin liên hệ:
Phone: 0395679924
Địa chỉ: nhà số 20, ngách49, ngõ 32 Đỗ Đức Dục, Nam Từ Liêm, Hà Nội 
Gmail: hitclubgamesite@gmail.com
Website: https://hitclubgame.site/
12000


# expose port 7080 (http) and 3306 (mysql) from any Docker container started by Habitat
export HAB_DOCKER_OPTS="-p 7080:7080 -p 3306:3306"

# launch and enter a Habitat studio
hab studio enter

# once the studio has finished loading, start all services with a local database
start-all

# clone a production instance's database
load-sql https://codeforphilly.org

# build and load the site, then wait for file changes
watch-site
```

At that point you should be able to see an instance at http://localhost:7080 and any edits should be reflected live

### Extend Laddr

For a permanent instance of laddr, you might want to consider deploying an *extending* project rather than laddr itself. [CodeForPhilly.org](https://codeforphilly.org) for example, is deployed from [a repository](https://github.com/CodeForPhilly/codeforphilly.org) that only contains a layer of customization that gets applied on top of laddr's repository. This gives you a place to change things like your brigade's logo or add new features without forking your own whole version of laddr.

To start a new extending project, initialize a new repository and copy the [`.holo/`](https://github.com/CodeForPhilly/codeforphilly.org/tree/develop/.holo) tree from the codeforphilly repository as a starting point. Replace `codeforphilly` with an identifier of your choice for your own project (maybe the repository name) in `.holo/config.toml` and rename `.holo/branches/emergence-site/_codeforphilly.toml` to match.

Then follow the same steps above to launch the project inside a container.

## Support

- [Laddr forum/wiki](http://forum.laddr.us/)
- [#laddr channel in Code for Philly's Slack](https://codeforphilly.org/chat/laddr)
- #laddr channel in Code for America's Slack
- [laddr issues on GitHub](https://github.com/CodeForPhilly/laddr/issues)
- [Emergence forum/wiki](http://forum.emr.ge)

## Features

- [Projects Directory]
  - Each project can have a users URL, developers URL, markdown README
  - Projects can be tagged by topic, tech, and event
  - [Projects list available via dynamic CSV] for linking to [CfAPI](https://github.com/codeforamerica/cfapi)
- [Members Directory]
  - Members can upload photos, write a bio in markdown, and tag themselves with topic and tech tags
- Meetup.com integration
  - Upcoming events pulled from meetup.com API for homepage sidebar
  - Current and next event highlighted
  - Members can checkin to current event and optionally pick what project they're working on
- Project Updates
  - Any project member can post markdown-formatted "updates" to a project
  - Updates show up on the [project's page], the [home page], the [global updates feed]
  - [RSS feeds for global] and [per-project updates]
- Project Buzz
  - Any site member can log a media article about a project
  - Attach photo and an exerpt
  - Buzz shows up on the [project's page], the [home page], and the [global buzz feed]
- [Big Screen]
  - A live status page for display during events
  - Latest member checkins to event
  - Markdown box for announcements
- Localizable
  - Language selector in the footer for visitors and configurable site-wide default language
  - English and Spanish translations available
  - Croatian and Korean translations in progress

## Brigades using Laddr

- [Code for Philly](http://codeforphilly.org)
  - [Extending repository](https://github.com/CodeForPhilly/codeforphilly.org)
- [Code for Dayton](http://codefordayton.org)
- [Code for Croatia](http://codeforcroatia.org)
- [Creative Commons Korea](http://labs.cckorea.org/)
- [Code for Cary](http://www.codeforcary.org/)
- [Code for Durham](http://codefordurham.com/)
- [Code for Raleigh](http://www.codeforraleigh.com/)
- [Open Charlotte Brigade](https://brigade.opencharlotte.org/)

[Projects Directory]: http://codeforphilly.org/projects
[Projects list available via dynamic CSV]: http://codeforphilly.org/projects.csv
[Members Directory]: http://codeforphilly.org/people
[project's page]: http://codeforphilly.org/projects/Bike_Route_Tracker
[home page]: http://codeforphilly.org
[global updates feed]: http://codeforphilly.org/project-updates
[RSS feeds for global]: http://codeforphilly.org/project-updates?format=rss
[per-project updates]: http://codeforphilly.org/project-updates?format=rss&ProjectID=40
[global buzz feed]: http://codeforphilly.org/project-buzz
[Big Screen]: http://codeforphilly.org/bigscreen
