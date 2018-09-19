{{ define "config.tpl" }}
{
    "ServiceSettings": {
        "SiteURL": {{ .Values.config.siteUrl | default "" | quote }},
        "LicenseFileLocation": "",
        "ListenAddress": ":8065",
        "ConnectionSecurity": "",
        "TLSCertFile": "",
        "TLSKeyFile": "",
        "UseLetsEncrypt": false,
        "LetsEncryptCertificateCacheFile": "./config/letsencrypt.cache",
        "Forward80To443": false,
        "ReadTimeout": 300,
        "WriteTimeout": 300,
        "MaximumLoginAttempts": 10,
        "GoroutineHealthThreshold": -1,
        "GoogleDeveloperKey": "",
        "EnableOAuthServiceProvider": false,
        "EnableIncomingWebhooks": true,
        "EnableOutgoingWebhooks": true,
        "EnableCommands": true,
        "EnableOnlyAdminIntegrations": false,
        "EnablePostUsernameOverride": false,
        "EnablePostIconOverride": false,
        "EnableLinkPreviews": false,
        "EnableTesting": false,
        "EnableDeveloper": false,
        "EnableSecurityFixAlert": true,
        "EnableInsecureOutgoingConnections": false,
        "EnableMultifactorAuthentication": false,
        "EnforceMultifactorAuthentication": false,
        "AllowCorsFrom": "",
        "SessionLengthWebInDays": 30,
        "SessionLengthMobileInDays": 30,
        "SessionLengthSSOInDays": 30,
        "SessionCacheInMinutes": 10,
        "WebsocketSecurePort": 443,
        "WebsocketPort": 80,
        "WebserverMode": "gzip",
        "EnableCustomEmoji": false,
        "RestrictCustomEmojiCreation": "all",
        "RestrictPostDelete": "all",
        "AllowEditPost": "always",
        "PostEditTimeLimit": 300,
        "TimeBetweenUserTypingUpdatesMilliseconds": 5000,
        "EnablePostSearch": true,
        "EnableUserTypingMessages": true,
        "EnableUserStatuses": true,
        "ClusterLogTimeoutMilliseconds": 2000
    },
    "TeamSettings": {
        "SiteName": {{ .Values.config.siteName | default "Mattermost" | quote }},
        "MaxUsersPerTeam": 50000,
        "EnableTeamCreation": true,
        "EnableUserCreation": true,
        "EnableOpenServer": true,
        "RestrictCreationToDomains": "",
        "EnableCustomBrand": false,
        "CustomBrandText": "",
        "CustomDescriptionText": "",
        "RestrictDirectMessage": "any",
        "RestrictTeamInvite": "all",
        "RestrictPublicChannelManagement": "all",
        "RestrictPrivateChannelManagement": "all",
        "RestrictPublicChannelCreation": "all",
        "RestrictPrivateChannelCreation": "all",
        "RestrictPublicChannelDeletion": "all",
        "RestrictPrivateChannelDeletion": "all",
        "RestrictPrivateChannelManageMembers": "all",
        "UserStatusAwayTimeout": 300,
        "MaxChannelsPerTeam": 50000,
        "MaxNotificationsPerChannel": 1000
    },
    "SqlSettings": {
        {{ if .Values.externalDB.enabled }}
        "DriverName": "{{ .Values.externalDB.externalDriverType }}",
        "DataSource": "{{ .Values.externalDB.externalConnectionString }}",
        {{ else }}
        "DriverName": "mysql",
        "DataSource": "{{ .Values.mysql.mysqlUser }}:{{ .Values.mysql.mysqlPassword }}@tcp({{ .Release.Name }}-mysql:3306)/{{ .Values.mysql.mysqlDatabase }}?charset=utf8mb4,utf8&readTimeout=30s&writeTimeout=30s",
        {{ end }}
        "DataSourceReplicas": [],
        "DataSourceSearchReplicas": [],
        "MaxIdleConns": 20,
        "MaxOpenConns": 35,
        "Trace": false,
        "AtRestEncryptKey": "{{ randAlphaNum 32 }}",
        "QueryTimeout": 30
    },
    "LogSettings": {
        "EnableConsole": true,
        "ConsoleLevel": "INFO",
        "EnableFile": true,
        "FileLevel": "INFO",
        "FileFormat": "",
        "FileLocation": "",
        "EnableWebhookDebugging": true,
        "EnableDiagnostics": true
    },
    "PasswordSettings": {
        "MinimumLength": 5,
        "Lowercase": false,
        "Number": false,
        "Uppercase": false,
        "Symbol": false
    },
    "FileSettings": {
        "EnableFileAttachments": true,
        "MaxFileSize": 52428800,
        {{ if .Values.config.filesAccessKey }}
        "DriverName": "amazons3",
        {{ else }}
        "DriverName": "local",
        {{ end }}
        "Directory": "./data/",
        "EnablePublicLink": false,
        "PublicLinkSalt": "{{ randAlphaNum 32 }}",
        "ThumbnailWidth": 120,
        "ThumbnailHeight": 100,
        "PreviewWidth": 1024,
        "PreviewHeight": 0,
        "ProfileWidth": 128,
        "ProfileHeight": 128,
        "InitialFont": "luximbi.ttf",
        "AmazonS3AccessKeyId": {{ .Values.config.filesAccessKey | default "" | quote }},
        "AmazonS3SecretAccessKey": {{ .Values.config.filesSecretKey | default "" | quote }},
        "AmazonS3Bucket": {{ .Values.config.fileBucketName | default "" | quote }},
        "AmazonS3Region": "",
        "AmazonS3Endpoint": "s3.amazonaws.com",
        "AmazonS3SSL": false,
        "AmazonS3SignV2": false
    },
    "EmailSettings": {
        "EnableSignUpWithEmail": true,
        "EnableSignInWithEmail": true,
        "EnableSignInWithUsername": true,
        {{ if .Values.config.smtpServer }}
        "SendEmailNotifications": true,
        {{ else }}
        "SendEmailNotifications": false,
        {{ end }}
        "RequireEmailVerification": false,
        "FeedbackName": {{ .Values.config.feedbackName | default "" | quote }},
        "FeedbackEmail": {{ .Values.config.feedbackEmail | default "" | quote }},
        "FeedbackOrganization": "",
        "SMTPUsername": {{ .Values.config.smtpUsername | default "" | quote }},
        "SMTPPassword": {{ .Values.config.smtpPassword | default "" | quote }},
        {{ if and .Values.config.smtpUsername .Values.config.smtpPassword }}
        "EnableSMTPAuth": true,
        {{ else }}
        "EnableSMTPAuth": false,
        {{ end }}
        "SMTPServer": {{ .Values.config.smtpServer | default "" | quote }},
        "SMTPPort": {{ .Values.config.smtpPort | default "" | quote }},
        "ConnectionSecurity": {{ .Values.config.smtpConnection | default "" | quote }},
        "InviteSalt": "{{ randAlphaNum 32 }}",
        "SendPushNotifications": true,
        "PushNotificationServer": "https://push.mattermost.com",
        "PushNotificationContents": "generic",
        "EnableEmailBatching": false,
        "EmailBatchingBufferSize": 256,
        "EmailBatchingInterval": 30,
        "SkipServerCertificateVerification": false
    },
    "RateLimitSettings": {
        "Enable": false,
        "PerSec": 10,
        "MaxBurst": 100,
        "MemoryStoreSize": 10000,
        "VaryByRemoteAddr": true,
        "VaryByHeader": ""
    },
    "PrivacySettings": {
        "ShowEmailAddress": true,
        "ShowFullName": true
    },
    "SupportSettings": {
        "TermsOfServiceLink": "https://about.mattermost.com/default-terms/",
        "PrivacyPolicyLink": "https://about.mattermost.com/default-privacy-policy/",
        "AboutLink": "https://about.mattermost.com/default-about/",
        "HelpLink": "https://about.mattermost.com/default-help/",
        "ReportAProblemLink": "https://about.mattermost.com/default-report-a-problem/",
        "SupportEmail": "feedback@mattermost.com"
    },
    "AnnouncementSettings": {
        "EnableBanner": false,
        "BannerText": "",
        "BannerColor": "#f2a93b",
        "BannerTextColor": "#333333",
        "AllowBannerDismissal": true
    },
{{ if .Values.auth.gitlab }}
    "GitLabSettings": {{ .Values.auth.gitlab | toJson }},
{{ end }}
    "LocalizationSettings": {
        "DefaultServerLocale": "en",
        "DefaultClientLocale": "en",
        "AvailableLocales": ""
    },
    "NativeAppSettings": {
        "AppDownloadLink": "https://about.mattermost.com/downloads/",
        "AndroidAppDownloadLink": "https://about.mattermost.com/mattermost-android-app/",
        "IosAppDownloadLink": "https://about.mattermost.com/mattermost-ios-app/"
    },
    "AnalyticsSettings": {
        "MaxUsersForStatistics": 2500
    },
    "WebrtcSettings": {
        "Enable": false,
        "GatewayWebsocketUrl": "",
        "GatewayAdminUrl": "",
        "GatewayAdminSecret": "",
        "StunURI": "",
        "TurnURI": "",
        "TurnUsername": "",
        "TurnSharedKey": ""
    },
    "DisplaySettings": {
        "CustomUrlSchemes": [],
        "ExperimentalTimezone": true
    },
    "TimezoneSettings": {
        "SupportedTimezonesPath": "timezones.json"
    },
    "PluginSettings": {
        "Enable": true,
        "EnableUploads": true,
        "Directory": "./plugins",
        "ClientDirectory": "./client/plugins",
        "Plugins": {},
        "PluginStates": {}
    }
}
{{ end }}
