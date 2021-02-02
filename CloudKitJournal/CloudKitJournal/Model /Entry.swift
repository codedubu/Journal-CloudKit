//
//  Entry.swift
//  CloudKitJournal
//
//  Created by River McCaine on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

struct EntryConstants {
    static let recordTypeKey = "Entry"
    /*fileprivate*/ static let titleKey = "title"
    /*fileprivate*/ static let bodyKey = "body"
    /*fileprivate*/ static let timestampKey = "timestamp"
} // END OF STRUCT

class Entry {
    var title: String
    var body: String
    var timestamp: Date
    var ckRecordID: CKRecord.ID
    
    init(title: String, body: String, timestamp: Date = Date(), ckRecordID: CKRecord.ID
         = CKRecord.ID(recordName: UUID().uuidString)) {
        self.title = title
        self.body = body
        self.timestamp = timestamp
        self.ckRecordID = ckRecordID
    }
} // END OF CLASS

extension CKRecord {
    convenience init(entry: Entry) {
        self.init(recordType: EntryConstants.recordTypeKey, recordID: entry.ckRecordID)
        self.setValuesForKeys([
            EntryConstants.titleKey : entry.title,
            EntryConstants.bodyKey : entry.body,
            EntryConstants.timestampKey : entry.timestamp
        ])
    }
} // END OF EXTENSION

extension Entry: Equatable {
    
    static func == (lhs: Entry, rhs: Entry) -> Bool {
        return lhs.ckRecordID == rhs.ckRecordID
    }
    
    convenience init?(ckRecord: CKRecord) {
        guard let title = ckRecord[EntryConstants.titleKey] as? String,
              let body = ckRecord[EntryConstants.bodyKey] as? String,
              let timestamp = ckRecord[EntryConstants.timestampKey] as? Date else { return nil }
        
        self.init(title: title, body:body, timestamp: timestamp, ckRecordID: ckRecord.recordID)
    }
} // END OF EXTENSION






// Less Swifty version... xD
//extension CKRecord{
//  convenience init(entry: Entry){
//    self.init(recordType: EntryContstants.RecordType, recordID: entry.ckRecordID)
//    self.setValue(entry.title, forKey: EntryContstants.TitleKey)
//    self.setValue(entry.body, forKey: EntryContstants.BodyKey)
//    self.setValue(entry.timestamp, forKey: EntryContstants.TimestampKey)
//  }
//}
