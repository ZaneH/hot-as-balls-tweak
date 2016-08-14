@interface WAWeatherCityView
- (UILabel *)pageTemperature;
- (UIView *)pageHeaderView;
- (UILabel *)pageConditionDescription;
@end

UIImageView *balls;

%hook WAWeatherCityView

- (void)updateUIIncludingExtendedWeather:(_Bool)arg1 {
	%orig;

	NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.zanehelton.hotasballs.plist"];
	int hotAsBallsTemp = [prefs[@"hotAsBallsTemp"] intValue];
	int coldAsBallsTemp = [prefs[@"coldAsBallsTemp"] intValue];

	NSString *tempString = [[[self pageTemperature] text] stringByReplacingOccurrencesOfString:@"°" withString:@""];
	int pageTemperature = [tempString intValue];

	if (pageTemperature >= hotAsBallsTemp) {
		%log(@(pageTemperature), @(hotAsBallsTemp));
		[[self pageTemperature] setHidden:YES];
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
		[[self pageHeaderView] addSubview:balls];
	} else if (pageTemperature <= coldAsBallsTemp) {
		[[self pageTemperature] setHidden:YES];
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
		[[self pageHeaderView] addSubview:balls];
	}
}

%end
