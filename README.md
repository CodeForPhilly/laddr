# laddr

Laddr -- pronounced "ladder" and named after the essential tool for fire brigades -- is a web application designed to create an online home-base for [Code for America brigades](http://brigade.codeforamerica.org).

## Hosting
Code for Philly hosts and maintains instances for free for other brigades on our multi-tenant infrastructure. Email [hello@codeforphilly.org](mailto:hello@codeforphilly.org) to get started with a sandbox instance.

## Help / Support / Questions / Chat
Guides and support are available at our Discourse foreum at [forum.laddr.us](http://forum.laddr.us/)

Join Code for Philly's Slack channel for Laddr, you can self-register via codeforphilly.org: [codeforphilly.org/chat/laddr](https://codeforphilly.org/chat/laddr)

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
- [Code for Dayton](http://codefordayton.org)
- [Code for Miami](http://codefor.miami/)
- [Code for Croatia](http://codeforcroatia.org)
- [Creative Commons Korea](http://labs.cckorea.org/)
- [Code for Cary](http://www.codeforcary.org/)
- [Code for Durham](http://codefordurham.com/)
- [Code for Raleigh](http://www.codeforraleigh.com/)
- [Open Charlotte Brigade](https://brigade.opencharlotte.org/)

## Requirements
Laddr is built on the Emergence PHP framework and deployement engine, and requires an Emergence server to host it.

Emergence takes just a few minutes to setup on a Linux VM, and is designed to have a fresh system to itself. Once launched
it will configure services on the machine as-needed to host an instance of the application along with any other
sites, clones, or child sites. The guides for Ubuntu and Gentoo are most up-to-date: http://emr.ge/docs/setup

## Installation via Emergence (linked child)
-  Create an emergence site that extends v2.laddr.us

## Installation from Git
-  Create an emergence site that extends skeleton.emr.ge (access key: 8U6kydil36bl3vlJ)
-  Upload contents of git repository using WebDAV client (CyberDuck is the best open-source option)


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
