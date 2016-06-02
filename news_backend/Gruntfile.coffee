module.exports = (grunt) ->
    grunt.initConfig(
        pkg: grunt.file.readJSON('package.json'),
        coffee:
            files:
                src: ['news_backend/src/js/**/*.coffee']
                dest: 'news_backend/assets/js/script.js'
        copy:
            main:
                files: [
                    {
                        expand: true,
                        cwd: 'news_backend/src/views',
                        src: ['**'],
                        dest: 'news_backend/assets/views/'
                    }
                    {
                        expand: true,
                        cwd: 'news_backend/src/data',
                        src: ['**'],
                        dest: 'news_backend/assets/data/'
                    }
                ]
        watch:
            scripts:
                files: ['news_backend/src/js/**/*.coffee']
                tasks: ['coffee']
            views:
                files: ['news_backend/src/views/**']
                tasks: ['copy']
    )
    grunt.loadNpmTasks('grunt-contrib-coffee')
    grunt.loadNpmTasks('grunt-contrib-watch')
    grunt.loadNpmTasks('grunt-contrib-copy')
    grunt.registerTask('default', ['coffee', 'copy', 'watch'])
    