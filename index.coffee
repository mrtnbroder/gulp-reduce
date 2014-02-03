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
            gzip: options.gzip or true
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

        new AssetGraph(root: defaults.rootUrl)

            .on 'afterTransform', (transform, elapsedTime) ->
                console.log((elapsedTime / 1000).toFixed(3) + ' secs: ' + transform.name)
            .on 'warn', (err) ->
                if err.relationType isnt 'JavaScriptCommonJsRequire'
                    console.warn((if err.asset then err.asset.urlOrDescription + ': ' else '') + err.message)
            .on 'error', (err) ->
                console.error((if err.asset then err.asset.urlOrDescription + ': ' else '') + err.stack)

            .registerRequireJsConfig()
            .loadAssets(defaults.loadAssets)
            .buildProduction(
                less: defaults.less
                optimizeImages: defaults.optimizeImages
                inlineSize: defaults.inlineSize
                autoprefix: defaults.autoprefix
                manifest: defaults.manifest
                asyncScripts: defaults.asyncScripts
                cdnRoot: defaults.cdnRoot
                prettyPrint: defaults.prettyPrint
                sharedBundles: defaults.sharedBundles
                gzip: defaults.gzip
            )
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
    #     @push file
    # done()

module.exports = gulpReduce
