define(['jquery'], function($) {
	var PasswordInput,
		__bind = function(fn, me) {
			return function() {
				return fn.apply(me, arguments);
			};
		},
		__indexOf = [].indexOf || function(item) {
				for (var i = 0, l = this.length; i < l; i++) {
					if (i in this && this[i] === item) return i;
				}
				return -1;
			};
	PasswordInput = (function() {
		function PasswordInput(element, options) {
			this.options = options;
			this.defaultCalculation = __bind(this.defaultCalculation, this);
			this.calculateStrength = __bind(this.calculateStrength, this);
			this.updateUI = __bind(this.updateUI, this);
			this.onKeyup = __bind(this.onKeyup, this);
			this.onToggleVisibility = __bind(this.onToggleVisibility, this);
			this.setBackgroundMeterPosition = __bind(this.setBackgroundMeterPosition, this);
			this.hideBackgroundMeter = __bind(this.hideBackgroundMeter, this);
			this.layoutMeter = __bind(this.layoutMeter, this);
			this.attachToToggleVisibilityIcon = __bind(this.attachToToggleVisibilityIcon, this);
			this.attachToToggleVisibilityText = __bind(this.attachToToggleVisibilityText, this);
			this.layoutInputGroup = __bind(this.layoutInputGroup, this);
			this.layoutToggleVisibilityLink = __bind(this.layoutToggleVisibilityLink, this);
			this.element = $(element);
			this.id = this.element.attr('id');
			this.isShown = false;
			this.i18n = this.options[this.options.lang];
			this.formGroupElement = this.element.parents('.form-group');
			if (!(this.formGroupElement.length > 0)) {
				$.error("Form input #" + this.id + " must have a surrounding form-group.");
			}
			this.formGroupElement.addClass('bootstrap-password');
			this.layoutInputGroup();
			this.layoutMeter();
			this.layoutToggleVisibilityLink();
			this.onKeyup();
			this.setBackgroundMeterPosition();
			$(window).resize(this.setBackgroundMeterPosition);
			this.element.keyup(this.onKeyup);
			this.attachToToggleVisibilityIcon();
			this.attachToToggleVisibilityText();
			this.modal = this.element.closest('.modal');
			if (this.modal.length === 0) {
				this.modal = null;
			}
			if (this.modal) {
				this.hideBackgroundMeter();
				this.modal.on('shown.bs.modal', this.setBackgroundMeterPosition);
				this.modal.on('hidden.bs.modal', this.hideBackgroundMeter);
			}
		}

		PasswordInput.prototype.layoutToggleVisibilityLink = function() {
			if (__indexOf.call(this.options.features, 'toggle-visibility-link') < 0) {
				return;
			}
			this.toggleVisibilityTextElement = $("<a href='#' class='toggle-visibility'>" + this.i18n.show + "</a>");
			return this.formGroupElement.append(this.toggleVisibilityTextElement);
		};

		PasswordInput.prototype.layoutInputGroup = function() {
			var addon, addonElement, addonKey, reachedInput, _i, _len, _ref, _results;
			if (__indexOf.call(this.options.features, 'input-group') < 0) {
				return;
			}
			this.inputGroupElement = this.element.parents('.input-group');
			if (this.inputGroupElement.length <= 0) {
				this.inputGroupElement = $('<div class="input-group"></div>');
				this.element.wrap(this.inputGroupElement);
			}
			reachedInput = false;
			_ref = this.options['input-group'].layout;
			_results = [];
			for (_i = 0, _len = _ref.length; _i < _len; _i++) {
				addonKey = _ref[_i];
				if (addonKey === 'input') {
					reachedInput = true;
					continue;
				}
				addon = this.options['input-group'].addons[addonKey];
				addonElement = $("<div class=\"input-group-addon\">\n    " + addon.html + "\n</div>");
				if (reachedInput) {
					_results.push(this.element.after(addonElement));
				}
				else {
					_results.push(this.element.before(addonElement));
				}
			}
			return _results;
		};

		PasswordInput.prototype.attachToToggleVisibilityText = function() {
			var _ref;
			this.toggleVisibilityTextElement = this.formGroupElement.find('a.toggle-visibility');
			if (this.toggleVisibilityTextElement.length <= 0) {
				this.toggleVisibilityTextElement = null;
			}
			return (_ref = this.toggleVisibilityTextElement) != null ? _ref.click(this.onToggleVisibility) : void 0;
		};

		PasswordInput.prototype.attachToToggleVisibilityIcon = function() {
			var _ref;
			this.toggleVisibilityIconElement = this.formGroupElement.find('.input-group').find('span.toggle-visibility');
			if (this.toggleVisibilityIconElement.length <= 0) {
				this.toggleVisibilityIconElement = null;
			}
			return (_ref = this.toggleVisibilityIconElement) != null ? _ref.click(this.onToggleVisibility) : void 0;
		};

		PasswordInput.prototype.layoutMeter = function() {
			var meterGroupElement;
			if (__indexOf.call(this.options.features, 'background-meter') >= 0) {
				this.formGroupElement.addClass('background-metered');
				this.backgroundMeterElement = $("<div class='background-meter' />");
				this.formGroupElement.append(this.backgroundMeterElement);
				meterGroupElement = this.backgroundMeterElement;
			}
			if (!meterGroupElement) {
				meterGroupElement = $("<div class='meter-group'/>");
				this.element.after(meterGroupElement);
			}
			this.meterElement = $("<div class='meter'>");
			this.meterLabelElement = $("<div>" + this.i18n.meter.none + "</div>");
			this.meterLabelElement.appendTo(this.meterElement);
			return meterGroupElement.append(this.meterElement);
		};

		PasswordInput.prototype.hideBackgroundMeter = function() {
			if (this.backgroundMeterElement == null) {
				return;
			}
			return this.meterElement.addClass('hidden');
		};

		PasswordInput.prototype.setBackgroundMeterPosition = function() {
			var backgroundMeterCss;
			if (this.backgroundMeterElement == null) {
				return;
			}
			console.debug("background-meter location set to: ", this.element.offset());
			backgroundMeterCss = {
				position: 'absolute',
				verticalAlign: this.element.css('verticalAlign'),
				width: this.element.css('width'),
				height: this.element.css('height'),
				borderRadius: this.element.css('borderRadius')
			};
			this.backgroundMeterElement.css(backgroundMeterCss);
			this.backgroundMeterElement.offset(this.element.offset());
			return this.meterElement.removeClass('hidden');
		};

		PasswordInput.prototype.onToggleVisibility = function(ev) {
			ev.preventDefault();
			if (this.isShown) {
				this.element.attr('type', 'password');
				if (this.toggleVisibilityIconElement) {
					this.toggleVisibilityIconElement.removeClass('hide-toggle-visibility').addClass('toggle-visibility');
				}
				if (this.toggleVisibilityTextElement) {
					this.toggleVisibilityTextElement.removeClass('hide-toggle-visibility').addClass('toggle-visibility').html(this.i18n.show);
				}
				return this.isShown = false;
			}
			else {
				this.element.attr('type', 'text');
				if (this.toggleVisibilityIconElement) {
					this.toggleVisibilityIconElement.removeClass('toggle-visibility').addClass('hide-toggle-visibility');
				}
				if (this.toggleVisibilityTextElement) {
					this.toggleVisibilityTextElement.removeClass('toggle-visibility').addClass('hide-toggle-visibility').html(this.i18n.hide);
				}
				return this.isShown = true;
			}
		};

		PasswordInput.prototype.onKeyup = function(ev) {
			var strength;
			strength = this.calculateStrength(this.element.val());
			return this.updateUI(strength);
		};

		PasswordInput.prototype.updateUI = function(strength) {
			var cssClass, _i, _len, _ref;
			_ref = ['strong', 'medium', 'weak', 'veryWeak', 'none'];
			for (_i = 0, _len = _ref.length; _i < _len; _i++) {
				cssClass = _ref[_i];
				this.formGroupElement.removeClass(cssClass);
			}
			this.formGroupElement.addClass(strength);
			switch (strength) {
				case 'strong':
				case 'medium':
				case 'weak':
				case 'none':
					return this.meterLabelElement.text(this.i18n.meter[strength]);
				default:
					return this.meterLabelElement.text(this.i18n.meter.veryWeak);
			}
		};

		PasswordInput.prototype.calculateStrength = function(newValue) {
			var calculation;
			if (typeof this.options.calculation === 'function') {
				calculation = this.options.calculation;
			}
			else {
				calculation = this.defaultCalculation;
			}
			return calculation(newValue, this.options);
		};

		PasswordInput.prototype.defaultCalculation = function(newValue, options) {
			if (newValue.length === 0) {
				return 'none';
			}
			else if (newValue.search(options.calculation.strongTest) >= 0) {
				return 'strong';
			}
			else if (newValue.search(options.calculation.mediumTest) >= 0) {
				return 'medium';
			}
			else if (newValue.search(options.calculation.weakTest) >= 0) {
				return 'weak';
			}
			else {
				return 'veryWeak';
			}
		};

		return PasswordInput;

	})();

	$.fn.extend({
		_defaultOptions: {
			lang: 'en',
			features: ['background-meter', 'input-group'],
			'input-group': {
				layout: ['password-strength', 'input', 'toggle-visibility'],
				addons: {
					'toggle-visibility': {
						html: '<span class="toggle-visibility icon-toggle-visibility" aria-hidden="true"></span>'
					},
					'password-strength': {
						html: '<span class="icon-password-strength" aria-hidden="true"></span>'
					}
				}
			},
			en: {
				meter: {
					veryWeak: 'Very Weak',
					weak: 'Weak',
					medium: 'Medium',
					strong: 'Strong',
					none: 'Strength'
				},
				show: 'Show',
				hide: 'Hide'
			},
			calculation: {
				weakTest: /^[a-zA-Z0-9]{6,}$/,
				mediumTest: /^(?=.*\d)(?=.*[a-z])(?!.*\s).{8,}$|^(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/,
				strongTest: /^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?!.*\s).{8,}$/
			}
		},
		bootstrapPassword: function(options) {
			var defaultOptions, _ref;
			if (options == null) {
				options = {};
			}
			defaultOptions = $.extend(true, {}, this._defaultOptions);
			if (((_ref = options['input-group']) != null ? _ref.layout : void 0) != null) {
				defaultOptions['input-group'].layout = null;
			}
			if (options['features'] != null) {
				defaultOptions['features'] = null;
			}
			this.options = $.extend(true, {}, defaultOptions, options);
			return this.each((function(_this) {
				return function() {
					if (!$.data(_this, 'bootstrapPassword')) {
						return $.data(_this, 'bootstrapPassword', new PasswordInput(_this, _this.options));
					}
				};
			})(this));
		}
	});
});

