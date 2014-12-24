module.exports = function(config) {
	config.set({

		// base path that will be used to resolve all patterns (eg. files, exclude)
		basePath: '.',


		// frameworks to use
		// available frameworks: https://npmjs.org/browse/keyword/karma-adapter
		frameworks: ['jasmine'], //, 'requirejs'],


		// list of files / patterns to load in the browser
		files: [
			// include this only for rubymine debug,
			//  rubymine run or cake test blows on it...not sure why.
//			'public/js/**/*.js.map',

			'public/css/vendor.css',
			'public/css/bootstrap-password.css',
//			'public/css/*.css.map',
//			'public/css/bootstrap/*.*',

			'public/js/vendor.js',
			'public/js/bootstrap-password.js',
			'bower_components/jasmine-jquery/lib/jasmine-jquery.js',
			'bower_components/jasmine-fixture/dist/jasmine-fixture.js',
			'app/spec/spec_helper.coffee',


			// individual files, debug only
//			'app/spec/lib/bootstrap-password.spec.coffee'

			// normal run files, all uncommented
			'app/spec/lib/helpers/*.spec.coffee',
			'app/spec/lib/*.spec.coffee',
			'app/spec/concerns/*.spec.coffee',
			'app/spec/**/*.spec.coffee' // catch-all


//			'test/**/*.js.map'
		],

		proxies: {
			"/base": "http://localhost:9876"
		},

		// web server port
		port: 9876,


		// list of files to exclude
		exclude: [

		],


		// preprocess matching files before serving them to the browser
		// available preprocessors: https://npmjs.org/browse/keyword/karma-preprocessor
		preprocessors: {
			'**/*.coffee': ['coffee']
		},

		coffeePreprocessor: {
			// options passed to the coffee compiler
			options: {
//				bare: true,
				sourceMap: true
			}//,
			// transforming the filenames
//			transformPath: function(path) {
//				return path.replace(/\.coffee$/, '.js');
//			}
		},

		// test results reporter to use
		// possible values: 'dots', 'progress'
		// available reporters: https://npmjs.org/browse/keyword/karma-reporter
		reporters: ['progress'],


		// enable / disable colors in the output (reporters and logs)
		colors: true,


		// level of logging
		// possible values: config.LOG_DISABLE || config.LOG_ERROR || config.LOG_WARN || config.LOG_INFO || config.LOG_DEBUG
		logLevel: config.LOG_INFO,


		// enable / disable watching file and executing tests whenever any file changes
		autoWatch: false,


		// start these browsers
		// available browser launchers: https://npmjs.org/browse/keyword/karma-launcher
		browsers: ['PhantomJS'],//, 'Chrome', 'Firefox'],


		// If browser does not capture in given timeout [ms], kill it
		// CLI --capture-timeout 5000
		captureTimeout: 20000,


		// Auto run tests on start (when browsers are captured) and exit
		// CLI --single-run --no-single-run
		singleRun: true,


		// report which specs are slower than 500ms
		// CLI --report-slower-than 500
		reportSlowerThan: 500,


		plugins: [
			'karma-jasmine',
//			'karma-requirejs',
			'karma-coffee-preprocessor',
			'karma-phantomjs-launcher',
			'karma-safari-launcher',
			'karma-chrome-launcher',
			'karma-firefox-launcher',
		]
	});
};
