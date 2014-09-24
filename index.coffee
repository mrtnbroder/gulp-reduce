'use strict'

through = require 'through2'
PluginError = (require 'gulp-util').PluginError
AssetGraph = require 'assetgraph-builder'
query = AssetGraph.query
urlTools = require 'urltools'

createPluginError = (message) ->
    new PluginError 'gulp-reduce', message

gulpReduce = (options = {}) ->

    # check validity of input
    # it's okay to throw here

    if typeof options isnt 'object'
        throw createPluginError 'options param needs to be an object'

    through.obj (file, enc, done) ->

        defaults =
            rootUrl: urlTools.fsDirToFileUrl(options.root or 'app')
            outRoot: urlTools.fsDirToFileUrl(options.outRoot or 'dist')
            cdnRoot: options.cdnRoot and urlTools.ensureTrailingSlash(options.cdnRoot)
            cdnOutRoot: options.cdnOutRoot and urlTools.fsDirToFileUrl(options.cdnOutRoot)
            optimizeImages: options.optimizeImages or true
            less: options.less or true
            asyncScripts: options.asyncScripts or true
            sharedBundles: options.sharedBundles or true
            inlineSize: options.inlineSize or 4096
            manifest: options.manifest or false
            prettyPrint: options.prettyPrint or true
            gzip: options.gzip or false
            loadAssets: file.relative or [
                '*.html'
                '.htaccess'
                '*.txt'
                '*.ico'
            ]
            autoprefix: options.autoprefix or [
                '> 1%'
                'last 2 versions'
                'Firefox ESR'
                'Opera 12.1'
            ]

        _settings =
            less: defaults.less
            optimizeImages: defaults.optimizeImages
            inlineSize: defaults.inlineSize
            autoprefix: defaults.autoprefix
            manifest: defaults.manifest
            asyncScripts: defaults.asyncScripts
            cdnRoot: defaults.cdnRoot
            prettyPrint: defaults.prettyPrint
            sharedBundles: defaults.sharedBundles
        if defaults.gzip is true
            _settings.gzip = true


        new AssetGraph(root: defaults.rootUrl)
            .logEvents()
            .registerRequireJsConfig()
            .loadAssets(defaults.loadAssets)
            .buildProduction(_settings)
            .writeAssetsToDisc(
                url: /^file:/
            ,
                defaults.outRoot
            )
            .if(defaults.cdnRoot)
                .writeAssetsToDisc(
                    url: query.createPrefixMatcher(defaults.cdnRoot)
                ,
                    defaults.cdnOutRoot or defaults.outRoot
                ,
                    defaults.cdnRoot
                )
            .endif()
            .writeStatsToStderr()
            .run(done)

module.exports = gulpReduce
