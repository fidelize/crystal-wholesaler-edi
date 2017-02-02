FROM crystallang/crystal:0.20.5
RUN mkdir /app
WORKDIR /app
ADD . /app
RUN shards install
RUN crystal build --release src/edi.cr
EXPOSE 3000
CMD ./edi start
