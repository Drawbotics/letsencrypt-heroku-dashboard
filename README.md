# letsencrypt-heroku-dashboard

We found a way to make the SSL certificate generation great again a few weeks ago, thanks to the awesome work by the substrakt team ([they blogged about it](https://substrakt.com/heroku-ssl-me-weve-come-a-long-way/)). 

Thanks to [letsencrypt-heroku](https://github.com/substrakt/letsencrypt-heroku/), it's now easy as a `GET` to an API to
- Generate an SSL cert on [Let's Encrypt](https://letsencrypt.org/)
- Verify it through DNS on [Cloudflare](https://www.cloudflare.com/)
- Add it to [Heroku](https://heroku.com)

## Introducing `letsencrypt-heroku-dashboard`

### New certificate
![Certificate](http://i.imgur.com/gNp2aSi.png)

--

### Certificates index
![Certificates](http://i.imgur.com/rxyF0Hi.png)

--

### Certificate show
![Certificate](http://i.imgur.com/X87J7ol.png)

## How to make it work ?

1. Follow the instructions & deploy the API at [substrakt's repo letsencrypt-heroku](https://github.com/substrakt/letsencrypt-heroku/)
2. Save the `auth_token`, you'll need it when you sign up to the dashboard
3. Deploy the dashboard [![Deploy](https://www.herokucdn.com/deploy/button.svg)](https://heroku.com/deploy)
4. The `API_PATH` is the URL on which your API is reachable, like `test-api-app.herokuapp.com` (note that you shouldn't put a `/` after the `.com`
5. It's deployed ! Sign up with your name, email, password & `auth_token`, which is gonna be linked to your user account

