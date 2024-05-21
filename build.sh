BASE_PATH="blog"
rm -rf "_site/${BASE_PATH}"
bundle exec jekyll b -d "_site/${BASE_PATH}"
bundle exec htmlproofer "_site/${BASE_PATH}" \
            \-\-disable-external \
            \-\-ignore-urls "/^http:\/\/127.0.0.1/,/^http:\/\/0.0.0.0/,/^http:\/\/localhost/"
