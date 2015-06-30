var src_path = './src/',
    prod_path = './app/';

module.exports = {
  src : {
    basedir: src_path,
    coffee : [
      src_path+'coffee/**/*.coffee',
      src_path+'coffee/main.coffee'
    ],
    jade : [
      src_path+'jade/**/*.jade'
    ],
    bootstrap: [
      src_path+'coffee/inc/**/*.coffee',
      src_path+'coffee/bootstrap.coffee'
    ],
    assets : [
      src_path+'assets/**/*'
    ]
  },
  prod : {
    basedir: prod_path,
    js : prod_path+'js',
    html : prod_path,
    assets : prod_path+'assets'
  },
  watch : {
    coffee : [src_path+'/coffee/**/*.coffee', '!'+src_path+'/coffee/bootstrap.coffee'],
    jade : src_path+'/jade/**/*.jade',
    bootstrap : [src_path+'coffee/inc/**/*.coffee', src_path+'/coffee/bootstrap.coffee']
  },
  onError: {
    title: "Error <%= error.plugin %> : <%= error.name %>",
    message: '\
<% if (typeof(error.message) !== "undefined") { %>\
  <%= error.message %>\
<% } %>\
<% if (typeof(error.filename) !== "undefined") { %>\
  in file <%= error.filename %>\
  <% if (typeof(error.location) !== "undefined") { %>\
    on line <%= error.location.first_line %> and col <%= error.location.first_column %>\
  <% } %>\
<% } %>'
  }
}