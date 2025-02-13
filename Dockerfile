FROM jekyll/jekyll:latest
WORKDIR /srv/jekyll
COPY . /srv/jekyll
RUN bundle install
EXPOSE 4000
CMD ["jekyll", "serve", "--host", "0.0.0.0"]