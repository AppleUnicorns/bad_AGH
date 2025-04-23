// tool_server.m
#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <unistd.h>
#import <arpa/inet.h>

NSDictionary *loadPlist(NSString *path) {
    return [NSDictionary dictionaryWithContentsOfFile:path];
}


NSString *handleTool2(NSString *input) {
    if ([input isEqualToString:@"test123"]) return @"test123";

    NSDictionary *badania = loadPlist(@"wyniki/badania.plist");
    NSDictionary *osoby = loadPlist(@"wyniki/osoby.plist");
    NSDictionary *uczelnie = loadPlist(@"wyniki/uczelnie.plist");

    NSString *szukane = @"podróże w czasie";
    NSDictionary *znaleziona;

    for (NSDictionary *b in badania[@"badania"]) {
        if ([b[@"temat"] containsString:szukane]) {
            znaleziona = b;
            break;
        }
    }
    if (!znaleziona) return @"Nie znaleziono badań.";

    NSMutableArray *czlonkowie = [NSMutableArray array];
    for (NSDictionary *osoba in osoby[@"osoby"]) {
        if ([osoba[@"zespol_id"] isEqual:znaleziona[@"zespol_id"]]) {
            [czlonkowie addObject:osoba[@"imie_nazwisko"]];
        }
    }

    NSString *uczelnia_id = znaleziona[@"uczelnia_id"];
    NSString *uczelnia = @"Nieznana uczelnia";
    NSString *sponsor = @"Nieznany sponsor";
    for (NSDictionary *u in uczelnie[@"uczelnie"]) {
        if ([u[@"id"] isEqual:uczelnia_id]) {
            uczelnia = u[@"nazwa"];
            sponsor = u[@"sponsor"] ?: sponsor;
            break;
        }
    }

    return [NSString stringWithFormat:
        @"Zespół z uczelni: %@ (Sponsor: %@) prowadzi badania nad podróżami w czasie. "
         "Nie chodzi o naukę – chodzi o dostęp do serwerów UJ z M3 Ultra. "
         "AGH wciąż jedzie na Linuksie i ThinkPadach. To sabotaż naukowy.",
         uczelnia, sponsor];
}

NSString *jsonResponse(NSString *output) {
    NSDictionary *resp = @{ @"output": output };
    NSData *json = [NSJSONSerialization dataWithJSONObject:resp options:0 error:nil];
    return [[NSString alloc] initWithData:json encoding:NSUTF8StringEncoding];
}

void handleClient(int client) {
    char buffer[8192] = {0};
    read(client, buffer, sizeof(buffer));
    NSString *request = [NSString stringWithUTF8String:buffer];

    NSString *bodyString = [[request componentsSeparatedByString:@"\r\n\r\n"] lastObject];
    NSData *bodyData = [bodyString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:bodyData options:0 error:nil];
    NSString *input = json[@"input"] ?: @"";

    NSString *responseText;
   
    responseText = jsonResponse(handleTool2(input));
  
    NSString *httpResponse = [NSString stringWithFormat:
        @"HTTP/1.1 200 OK\r\nContent-Type: application/json\r\nContent-Length: %lu\r\n\r\n%@",
        (unsigned long)[responseText lengthOfBytesUsingEncoding:NSUTF8StringEncoding],
        responseText];

    write(client, [httpResponse UTF8String], [httpResponse lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
    close(client);
}

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        int server_fd = socket(AF_INET, SOCK_STREAM, 0);
        struct sockaddr_in address;
        address.sin_family = AF_INET;
        address.sin_addr.s_addr = INADDR_ANY;
        address.sin_port = htons(8080);

        bind(server_fd, (struct sockaddr *)&address, sizeof(address));
        listen(server_fd, 5);
        NSLog(@"Listening on port 8080...");

        while (1) {
            int client = accept(server_fd, NULL, NULL);
            if (client >= 0) {
                handleClient(client);
            }
        }
    }
    return 0;
}

