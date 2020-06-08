# Test task for sitt

* Ruby version: 2.7.1

* System dependencies
  
```bash
bundle install
```

* Database creation

```bash
rails db:create
rails db:migrate
```

* Database initialization

```bash
rails db:seed
```

* How to run the test suite

```bash
bundle exec rspec
```

* Make first request

```bash
curl localhost:3000/posts\?page\[size\]=5\&page\[before\]=12
```
