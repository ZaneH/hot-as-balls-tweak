@interface WAWeatherCityView
- (UILabel *)pageTemperature;
- (UIView *)pageHeaderView;
- (UILabel *)pageConditionDescription;
@end

UIImageView *balls;

%hook WAWeatherCityView

- (void)updateUIIncludingExtendedWeather:(_Bool)arg1 {
	%orig;

	if (balls) {
		[balls removeFromSuperview];
		balls = nil;
	}

	[[self pageTemperature] setTextColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:1.0f]];

	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.zanehelton.hotasballs.plist"];
	int hotAsBallsTemp = [prefs[@"hotAsBallsTemp"] intValue];
	int coldAsBallsTemp = [prefs[@"coldAsBallsTemp"] intValue];

	NSString *tempString = [[[self pageTemperature] text] stringByReplacingOccurrencesOfString:@"°" withString:@""];
	int pageTemperature = [tempString intValue];

	if (pageTemperature >= hotAsBallsTemp) {
		[[self pageTemperature] setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
		[[self pageConditionDescription] setFrame:CGRectMake([self pageConditionDescription].frame.origin.x,
															 [self pageConditionDescription].frame.origin.y,
														     [self pageConditionDescription].superview.frame.size.width,
														     [self pageConditionDescription].frame.size.height)];
		[[self pageConditionDescription] setText:[NSString stringWithFormat:@"It's hot as balls (%i°)", pageTemperature]];

		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.zanehelton.hotasballs.bundle"];
		balls = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"hot-balls" ofType:@"png"]]];
		[balls setContentMode:UIViewContentModeScaleAspectFill];

		[balls setFrame:CGRectMake([self pageTemperature].frame.origin.x,
								   [self pageTemperature].frame.origin.y + 15,
								   [self pageTemperature].frame.size.width,
								   [self pageTemperature].frame.size.height)];
		[[self pageTemperature] addSubview:balls];

		[balls setTranslatesAutoresizingMaskIntoConstraints:NO];
		NSDictionary *views = NSDictionaryOfVariableBindings(balls);

		[[self pageTemperature] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[balls]|"
																			  options:0
																			  metrics:nil
																				views:views]];
		[[self pageTemperature] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[balls]|"
																			  options:0
																			  metrics:nil
																				views:views]];
	} else if (pageTemperature <= coldAsBallsTemp) {
		[[self pageTemperature] setTextColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.0f]];
		[[self pageConditionDescription] setFrame:CGRectMake([self pageConditionDescription].frame.origin.x,
															 [self pageConditionDescription].frame.origin.y,
														     [self pageConditionDescription].superview.frame.size.width,
														     [self pageConditionDescription].frame.size.height)];
		[[self pageConditionDescription] setText:[NSString stringWithFormat:@"It's cold as balls (%i°)", pageTemperature]];

		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.zanehelton.hotasballs.bundle"];
		balls = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"cold-balls" ofType:@"png"]]];
		[balls setContentMode:UIViewContentModeScaleAspectFill];

		[balls setFrame:CGRectMake([self pageTemperature].frame.origin.x,
								   [self pageTemperature].frame.origin.y + 15,
								   [self pageTemperature].frame.size.width,
								   [self pageTemperature].frame.size.height)];
		[[self pageTemperature] addSubview:balls];

		[balls setTranslatesAutoresizingMaskIntoConstraints:NO];
		NSDictionary *views = NSDictionaryOfVariableBindings(balls);

		[[self pageTemperature] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[balls]|"
		                                                                      options:0
		                                                                      metrics:nil
		                                                                        views:views]];
		[[self pageTemperature] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[balls]|"
		                                                                      options:0
		                                                                      metrics:nil
		                                                                        views:views]];
	}
}

%end
