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

	NSString *tempString = [[[self pageTemperature] text] stringByReplacingOccurrencesOfString:@"°" withString:@""];
	int pageTemperature = [tempString intValue];
	if (pageTemperature >= 90) {
		[[self pageTemperature] setHidden:YES];
		NSBundle *bundle = [[NSBundle alloc] initWithPath:@"/Library/MobileSubstrate/DynamicLibraries/com.zanehelton.hotasballs.bundle"];
		balls = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[bundle pathForResource:@"balls" ofType:@"png"]]];
		[balls setContentMode:UIViewContentModeScaleAspectFill];
		[balls setFrame:[self pageTemperature].frame];
		[[self pageHeaderView] addSubview:balls];
		[[self pageConditionDescription] setFrame:CGRectMake([self pageConditionDescription].frame.origin.x,
															 [self pageConditionDescription].frame.origin.y,
														     [self pageConditionDescription].superview.frame.size.width,
														     [self pageConditionDescription].frame.size.height)];
		[[self pageConditionDescription] setText:[NSString stringWithFormat:@"It's hot as balls (%i°)", pageTemperature]];
	}
}

%end
