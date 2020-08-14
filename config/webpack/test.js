process.env.NODE_ENV = process.env.NODE_ENV || 'development'

const environment = require('./environment')

$(document).ready(function() {
    $('.js-example-basic-multiple').select2();
});

module.exports = environment.toWebpackConfig()


