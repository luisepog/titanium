#import "teamID.h"

NSString *get_teamID_from_code_signature(NSString *executable_path)
{
    if (executable_path.length == 0) {
        NSLog(@"[TeamID] Executable path not found");
        return nil;
    }

    NSLog(@"[TeamID] Executable path: %@", executable_path);

    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, (__bridge CFStringRef)executable_path, kCFURLPOSIXPathStyle, false);
    if (!url) {
        NSLog(@"[TeamID] Failed to create CFURL for executable path");
        return nil;
    }

    SecStaticCodeRef staticCode = NULL;
    OSStatus status = SecStaticCodeCreateWithPath(url, 0, &staticCode);
    CFRelease(url);

    if (status != errSecSuccess || !staticCode) {
        NSLog(@"[TeamID] SecStaticCodeCreateWithPath failed: %d", (int)status);
        return nil;
    }

    CFDictionaryRef info = NULL;
    status = SecCodeCopySigningInformation(staticCode, kSecCSSigningInformation, &info);
    CFRelease(staticCode);

    if (status != errSecSuccess || !info) {
        NSLog(@"[TeamID] SecCodeCopySigningInformation failed: %d", (int)status);
        return nil;
    }

    CFStringRef teamIDRef = CFDictionaryGetValue(info, kSecCodeInfoTeamIdentifier);
    if (!teamIDRef || CFGetTypeID(teamIDRef) != CFStringGetTypeID()) {
        NSLog(@"[TeamID] No Team ID found in signing info");
        CFRelease(info);
        return nil;
    }

    char buffer[256];
    if (!CFStringGetCString(teamIDRef, buffer, sizeof(buffer), kCFStringEncodingUTF8)) {
        NSLog(@"[TeamID] Failed to convert Team ID string");
        CFRelease(info);
        return nil;
    }

    CFRelease(info);
    return [NSString stringWithUTF8String:buffer];
}


NSString *get_team_identifier_NSString(NSString *executable_path)
{
    NSString *teamID = get_teamID_from_code_signature(executable_path);
    if (teamID.length > 0) return teamID;
    return nil;
}

