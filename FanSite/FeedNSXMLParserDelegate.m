//
//  FanSiteFeedNSXMLParserDelegate.m
//  FanSite
//
//  Created by Philip Nichols on 8/18/14.
//  Copyright (c) 2014 Phil Nichols. All rights reserved.
//

#import "FeedNSXMLParserDelegate.h"

@interface FeedNSXMLParserDelegate ()

@property (strong, nonatomic, readwrite) NSArray *feed;
@property (strong, nonatomic) NSMutableArray *xmlFeed;

@property (strong, nonatomic) NSMutableDictionary *currentDictionary;
@property (strong, nonatomic) NSString *elementName;
@property (strong, nonatomic) NSMutableString *outstring;

@end

@implementation FeedNSXMLParserDelegate

#pragma mark - NSXMLParserDelegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.xmlFeed = [NSMutableArray array];
}

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict
{
    self.elementName = elementName;
    
    if ([elementName isEqualToString:@"item"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    
    self.outstring = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (!self.elementName) {
        return;
    }
    
    [self.outstring appendFormat:@"%@", string];
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"item"]) {
        [self.xmlFeed addObject:self.currentDictionary];
        self.currentDictionary = nil;
    } else if ([elementName isEqualToString:@"title"] ||
               [elementName isEqualToString:@"pubDate"] ||
               [elementName isEqualToString:@"link"]) {
        self.currentDictionary[elementName] = self.outstring;
    }

    self.elementName = nil;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    self.feed = self.xmlFeed;
}

@end
