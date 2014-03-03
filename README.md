KVCParsing
==========

Easy JSON parsing using the built-in Key Value Coding (KVC) layer.

Using **KVCParsing** you are not creating a "parser" object. Your NSObjects will be fully responsible of parsing your JSON dictionaries by themselves using the Cocoa built-in Key-Value-Coding layer.

##How To
####1. Define the parsing keys

Your custom object (subclass of `NSObject`) needs to override the method `mappingForKVCParsing` and define the mappging from the JSON keys to the Objective-C property names.

	- (NSDictionary*)mappingForKVCParsing
	{
    	return @{@"json_attribute_key_1" : @"class_property_name_1",
    			 @"json_attribute_key_2" : @"class_property_name_2",
    			 ...
    			 @"json_attribute_key_N" : @"class_property_name_N",
    			 };
	}
	
Remember that you might want to add also the dictionary from the call `[super mappgngForKVCParsing]` to your custom mapping.

####2. Parse and set your objects

After defining your mappings in step (1) you are ready to go:

	- (void)parseTest
	{
		// Some JSON object
		NSDictionary *jsonObject = [...];
		
		// Creating an instance of your class
		MyClass instance = [[MyClass alloc] init];
				
		// Parsing and setting the values of the JSON object
		[instance parseValuesForKeysWithDictionary:jsonObject];
	}
	
####3. Value Validation

As an extra feature, you can validate your objects and change the type of your values on the go. The validation is done via KVC validation and is enabled by default (you can disable it by setting the property `validatesKVCParsing` to NO).

With KVC, you validate values by implementing the methods for each key:

	- (BOOL)validate<Key>:(id *)ioValue error:(NSError * __autoreleasing *)outError
	{
		// Check *ioValue and assign new value to ioValue if needed.
		// Return YES if *ioValue can be assigned to the attribute, NO otherwise
		
		return YES; 
	}
	
For example, lets consider we are parsing a JSON of a `Video` object that contains inside a `User` description as a dictionary for the `uploader` key. Our implementation would do:

	- (BOOL)validateUploader:(id *)ioValue error:(NSError * __autoreleasing *)outError
	{
		// If the uplaoder is a dictionary
		if ([*ioValue isKindOfClass:[NSDictionary class]])
		{
			// Create a new instance of uploader
			User uploader = [[User alloc] init];
			
			// Populate the uploader with the key-value contained in *ioValue
			[uploader parseValuesForKeysWithDictionary:*ioValue];
			
			// Reasign the new value
			*ioValue = uploader;
		}			
		
		// Finally, return YES
		return YES; 
	}