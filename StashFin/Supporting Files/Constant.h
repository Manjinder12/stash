//
//  Constants.h
//

#ifndef HS_Constants_h
#define HS_Constants_h

//----------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark - WEBSERVICE URL


#define BASE_URL @"http://api.stashfin.com/StashfinApp/android"
#define BASE_URL_OLD @"http://api.stashfin.com/webServicesMobile/StasheasyApp"
//#define BASE_URL_OLD @"https://devapi.stasheasy.com/webServicesMobile/StasheasyApp" //Dev


#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define BUTTON_BG_COLOR                              [UIColor colorWithRed:85.0/255.0 green:138.0/255.0 blue:243.0/255.0 alpha:1]
#define TEXT_BG_COLOR                                [UIColor colorWithRed:236.0/255.0 green:236.0/255.0 blue:236.0/255.0 alpha:1.0]
#define ORANGE_BG_COLOR                              [UIColor colorWithRed:250.0/255.0 green:175.0/255.0 blue:58.0/255.0 alpha:1.0]
#define ROSE_PINK_COLOR                              [UIColor colorWithRed:250.0/255.0 green:51.0/255.0 blue:74.0/255.0 alpha:1]


#define LikeCommentSaveFont         [ApplicationUtils GETFONT_REGULAR:14]
#define TabBarFont                  [ApplicationUtils GETFONT_REGULAR:15]
#define DetailViewTitleTagFont      [ApplicationUtils GETFONT_MEDIUM:17]
#define DetailViewDescriptionFont   [ApplicationUtils GETFONT_REGULAR:17]
#define ButtonFont                  [ApplicationUtils GETFONT_MEDIUM:15]


#define LOGIN_STATUS            @"isUserLogin"
#define LOGIN_DATA              @"LOGIN_DATA"

#define MOBILE_NUMBER_LENGTH        10
#define OTP_LENGTH                  4

//Do not change thsese tags
#define FIELD_LABEL_TAG         100
#define FIELD_TEXTFIELD_TAG     101
#define FIELD_GREEN_MARK_TAG    102
#define FIELD_SEPERATOR_TAG     103
#define FIELD_DROPDWON_TAG      104
#define FIELD_RADIO1_TAG        105
#define FIELD_RADIO2_TAG        106


#define FACEBOOK_TAG        100
#define GOOGLE_TAG          101

#define FB_LOGIN_NOTIFICATION       @"FB_LOGIN_NOTIFICATION"
#define EMAIL_KEY                   @"EMAIL"
#define GENDER_KEY                  @"GENDER"
#define DOB_KEY                     @"DOB"
#define PROFILE_IMAGE_KEY           @"PROFILE_IMAGE"
#define FIRST_NAME_KEY              @"FNAME"
#define LAST_NAME_KEY               @"LNAME"
#define USERNAME_KEY                @"USERNAME"
#define SOCIAL_ID                   @"SOCIAL_ID"
#define SOCIAL_SOURCE               @"SOCIAL_SOURCE"
#define ACCESS_TOKEN                @"ACCESS_TOKEN"
#define MOBILE_NUMBER_KEY           @"MOBILE_NUMBER"
#define REFERRAL_CODE               @"REFERRAL_CODE"
#define COMPANY_KEY                 @"COMPANY"
#define SALARY_KEY                  @"SALARY"


//-------------------------------------------------------------------------------------------------
#define API_GET_HOME_GRID_URL                 @"/rest/pin/home"


//-----------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark - Extra Constants

#define DATE_FORMATTER                        @"dd-MMM-yyyy"
#define DATE_FORMAT_DOB                       @"YYYY-MM-dd"


#endif


