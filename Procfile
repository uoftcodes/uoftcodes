web: bin/rails server -p $PORT -e $RAILS_ENV & bundle exec sidekiq & wait -n
release: rake db:migrate
