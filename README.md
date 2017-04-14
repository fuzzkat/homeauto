# Home Automation Router
This project acts as a router for requests coming from Alexa (via Fauxmo) to various IOT appliances in my home.

It depends on [fauxmo](https://github.com/makermusings/fauxmo) to capture the incoming requests from Alexa and Sidekiq for queueing control events, so that Alexa doesn't time out and complain that the "device is not responding".

## HomeEasy HE840IP
HomeEasy home automation AKA
* Smartwares Safety &amp; Lighting
* Byron Smartwares

The HE840IP is an IP gateway for HomeEasy RF controlled switches and light fittings. It uses a RESTful JSON API. The homeeasy class wraps the required REST calls in a simple ruby API, using a user-aware rest client to keep a session open or create a new one when timed out.

## TV
There are calls to local scripts that use SSH to drive LIRC controlling a TV, Amp and MythTV Client box.

