//  Project name: FwiData
//  File name   : FwiData.swift
//
//  Author      : Phuc.rawValue Tran Huu
//  Created date: 12/3/14
//  Version     : 1.00
//  --------------------------------------------------------------
//  Copyright (c) 2014 Monster Group. All rights reserved.
//  --------------------------------------------------------------
//
//  Permission is hereby granted, free of charge, to any person obtaining  a  copy
//  of this software and associated documentation files (the "Software"), to  deal
//  in the Software without restriction, including without limitation  the  rights
//  to use, copy, modify, merge,  publish,  distribute,  sublicense,  and/or  sell
//  copies of the Software,  and  to  permit  persons  to  whom  the  Software  is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF  ANY  KIND,  EXPRESS  OR
//  IMPLIED, INCLUDING BUT NOT  LIMITED  TO  THE  WARRANTIES  OF  MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO  EVENT  SHALL  THE
//  AUTHORS OR COPYRIGHT HOLDERS  BE  LIABLE  FOR  ANY  CLAIM,  DAMAGES  OR  OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING  FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  THE
//  SOFTWARE.
//
//
//  Disclaimer
//  __________
//  Although reasonable care has been taken to  ensure  the  correctness  of  this
//  software, this software should never be used in any application without proper
//  testing. Monster Group  disclaim  all  liability  and  responsibility  to  any
//  person or entity with respect to any loss or damage caused, or alleged  to  be
//  caused, directly or indirectly, by the use of this software.

import Foundation
import FwiCore


// Network Status Values
public let NetworkStatus_Unknown: Int32                          = CFNetworkErrors.CFURLErrorUnknown.rawValue
public let NetworkStatus_Cancelled: Int32                        = CFNetworkErrors.CFURLErrorCancelled.rawValue
public let NetworkStatus_BadURL: Int32                           = CFNetworkErrors.CFURLErrorBadURL.rawValue
public let NetworkStatus_TimedOut: Int32                         = CFNetworkErrors.CFURLErrorTimedOut.rawValue
public let NetworkStatus_UnsupportedURL: Int32                   = CFNetworkErrors.CFURLErrorUnsupportedURL.rawValue
public let NetworkStatus_CannotFindHost: Int32                   = CFNetworkErrors.CFURLErrorCannotFindHost.rawValue
public let NetworkStatus_CannotConnectToHost: Int32              = CFNetworkErrors.CFURLErrorCannotConnectToHost.rawValue
public let NetworkStatus_NetworkConnectionLost: Int32            = CFNetworkErrors.CFURLErrorNetworkConnectionLost.rawValue
public let NetworkStatus_DNSLookupFailed: Int32                  = CFNetworkErrors.CFURLErrorDNSLookupFailed.rawValue
public let NetworkStatus_HTTPTooManyRedirects: Int32             = CFNetworkErrors.CFURLErrorHTTPTooManyRedirects.rawValue
public let NetworkStatus_ResourceUnavailable: Int32              = CFNetworkErrors.CFURLErrorResourceUnavailable.rawValue
public let NetworkStatus_NotConnectedToInternet: Int32           = CFNetworkErrors.CFURLErrorNotConnectedToInternet.rawValue
public let NetworkStatus_RedirectToNonExistentLocation: Int32    = CFNetworkErrors.CFURLErrorRedirectToNonExistentLocation.rawValue
public let NetworkStatus_BadServerResponse: Int32                = CFNetworkErrors.CFURLErrorBadServerResponse.rawValue
public let NetworkStatus_UserCancelledAuthentication: Int32      = CFNetworkErrors.CFURLErrorUserCancelledAuthentication.rawValue
public let NetworkStatus_UserAuthenticationRequired: Int32       = CFNetworkErrors.CFURLErrorUserAuthenticationRequired.rawValue
public let NetworkStatus_ZeroByteResource: Int32                 = CFNetworkErrors.CFURLErrorZeroByteResource.rawValue
public let NetworkStatus_CannotDecodeRawData: Int32              = CFNetworkErrors.CFURLErrorCannotDecodeRawData.rawValue
public let NetworkStatus_CannotDecodeContentData: Int32          = CFNetworkErrors.CFURLErrorCannotDecodeContentData.rawValue
public let NetworkStatus_CannotParseResponse: Int32              = CFNetworkErrors.CFURLErrorCannotParseResponse.rawValue
public let NetworkStatus_FileDoesNotExist: Int32                 = CFNetworkErrors.CFURLErrorFileDoesNotExist.rawValue
public let NetworkStatus_FileIsDirectory: Int32                  = CFNetworkErrors.CFURLErrorFileIsDirectory.rawValue
public let NetworkStatus_NoPermissionsToReadFile: Int32          = CFNetworkErrors.CFURLErrorNoPermissionsToReadFile.rawValue
public let NetworkStatus_DataLengthExceedsMaximum: Int32         = CFNetworkErrors.CFURLErrorDataLengthExceedsMaximum.rawValue
// SSL errors
public let NetworkStatus_SecureConnectionFailed: Int32           = CFNetworkErrors.CFURLErrorSecureConnectionFailed.rawValue
public let NetworkStatus_ServerCertificateHasBadDate: Int32      = CFNetworkErrors.CFURLErrorServerCertificateHasBadDate.rawValue
public let NetworkStatus_ServerCertificateUntrusted: Int32       = CFNetworkErrors.CFURLErrorServerCertificateUntrusted.rawValue
public let NetworkStatus_ServerCertificateHasUnknownRoot: Int32  = CFNetworkErrors.CFURLErrorServerCertificateHasUnknownRoot.rawValue
public let NetworkStatus_ServerCertificateNotYetValid: Int32     = CFNetworkErrors.CFURLErrorServerCertificateNotYetValid.rawValue
public let NetworkStatus_ClientCertificateRejected: Int32        = CFNetworkErrors.CFURLErrorClientCertificateRejected.rawValue
public let NetworkStatus_ClientCertificateRequired: Int32        = CFNetworkErrors.CFURLErrorClientCertificateRequired.rawValue
public let NetworkStatus_CannotLoadFromNetwork: Int32            = CFNetworkErrors.CFURLErrorCannotLoadFromNetwork.rawValue
// Download and file I/O errors
public let NetworkStatus_CannotCreateFile: Int32                 = CFNetworkErrors.CFURLErrorCannotCreateFile.rawValue
public let NetworkStatus_CannotOpenFile: Int32                   = CFNetworkErrors.CFURLErrorCannotOpenFile.rawValue
public let NetworkStatus_CannotCloseFile: Int32                  = CFNetworkErrors.CFURLErrorCannotCloseFile.rawValue
public let NetworkStatus_CannotWriteToFile: Int32                = CFNetworkErrors.CFURLErrorCannotWriteToFile.rawValue
public let NetworkStatus_CannotRemoveFile: Int32                 = CFNetworkErrors.CFURLErrorCannotRemoveFile.rawValue
public let NetworkStatus_CannotMoveFile: Int32                   = CFNetworkErrors.CFURLErrorCannotMoveFile.rawValue
public let NetworkStatus_DownloadDecodingFailedMidStream: Int32  = CFNetworkErrors.CFURLErrorDownloadDecodingFailedMidStream.rawValue
public let NetworkStatus_DownloadDecodingFailedToComplete: Int32 = CFNetworkErrors.CFURLErrorDownloadDecodingFailedToComplete.rawValue
// ???
public let NetworkStatus_InternationalRoamingOff: Int32          = CFNetworkErrors.CFURLErrorInternationalRoamingOff.rawValue
public let NetworkStatus_CallIsActive: Int32                     = CFNetworkErrors.CFURLErrorCallIsActive.rawValue
public let NetworkStatus_DataNotAllowed: Int32                   = CFNetworkErrors.CFURLErrorDataNotAllowed.rawValue
public let NetworkStatus_RequestBodyStreamExhausted: Int32       = CFNetworkErrors.CFURLErrorRequestBodyStreamExhausted.rawValue
// 4xx Client Error
public let NetworkStatus_BadRequest: Int32                       = 400
public let NetworkStatus_UnauthorizedAccess: Int32               = 401
public let NetworkStatus_PaymentRequired: Int32                  = 402
public let NetworkStatus_Forbidden: Int32                        = 403
public let NetworkStatus_NotFound: Int32                         = 404
public let NetworkStatus_MethodNotAllowed: Int32                 = 405
public let NetworkStatus_NotAcceptable: Int32                    = 406
public let NetworkStatus_ProxyAuthenticationRequired: Int32      = 407
public let NetworkStatus_RequestTimeout: Int32                   = 408
public let NetworkStatus_Conflict: Int32                         = 409
public let NetworkStatus_Gone: Int32                             = 410
public let NetworkStatus_LengthRequired: Int32                   = 411
public let NetworkStatus_PreconditionFailed: Int32               = 412
public let NetworkStatus_RequestEntityTooLarge: Int32            = 413
public let NetworkStatus_RequestUriTooLarge: Int32               = 414
public let NetworkStatus_UnsupportedMediaType: Int32             = 415
public let NetworkStatus_RequestedRangeNotSatisfiable: Int32     = 416
public let NetworkStatus_ExpectationFailed: Int32                = 417
public let NetworkStatus_Teapot: Int32                           = 418
public let NetworkStatus_UnprocessableEntity: Int32              = 422
public let NetworkStatus_Locked: Int32                           = 423
public let NetworkStatus_FailedDependency: Int32                 = 424
public let NetworkStatus_UnorderedCollection: Int32              = 425
public let NetworkStatus_UpgradeRequired: Int32                  = 426
public let NetworkStatus_PreconditionRequired: Int32             = 428
public let NetworkStatus_TooManyRequests: Int32                  = 429
public let NetworkStatus_RequestHeaderFieldsTooLarge: Int32      = 431
// 5xx Server Error
public let NetworkStatus_InternalServerError: Int32              = 500
public let NetworkStatus_NotImplemented: Int32                   = 501
public let NetworkStatus_BadGateway: Int32                       = 502
public let NetworkStatus_ServiceUnavailable: Int32               = 503
public let NetworkStatus_GatewayTimeout: Int32                   = 504
public let NetworkStatus_HTTPVersionNotSupported: Int32          = 505
public let NetworkStatus_VariantAlsoNegotiates: Int32            = 506
public let NetworkStatus_InsufficientStorage: Int32              = 507
public let NetworkStatus_LoopDetected: Int32                     = 508
public let NetworkStatus_NetworkAuthenticationRequired: Int32    = 511


// HTTP Methods
public enum FwiHttpMethod: UInt8 {
    case Copy    = 0x00
    case Delete  = 0x01
    case Get     = 0x02
    case Head    = 0x03
    case Link    = 0x04
    case Options = 0x05
    case Patch   = 0x06
    case Post    = 0x07
    case Purge   = 0x08
    case Put     = 0x09
    case Unlink  = 0x0a
}


// Network Functions
public func FwiNetworkStatusIsSuccces(networkStatus: Int32) -> Bool {
    return (200 <= networkStatus && networkStatus <= 299)
}