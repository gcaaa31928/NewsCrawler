module.exports = (grunt) ->
    grunt.initConfig(
        pkg: grunt.file.readJSON('package.json'),
        coffee:
            files:
                src: ['news_backend/src/js/**/*.coffee']
                dest: 'news_backend/assets/js/script.js'
        watch:
            files: ['news_backend/src/js/**/*.coffee']
            tasks: ['coffee']
    )
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch');
    grunt.registerTask('default', 'coffee', 'watch')