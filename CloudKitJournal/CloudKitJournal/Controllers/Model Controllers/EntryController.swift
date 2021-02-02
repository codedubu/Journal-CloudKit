//
//  EntryController.swift
//  CloudKitJournal
//
//  Created by River McCaine on 2/1/21.
//  Copyright © 2021 Zebadiah Watson. All rights reserved.
//

import CloudKit

class EntryController {
    // MARK: - Properties
    // Shared Instance
    static let shared = EntryController()
    // Source of Truth
    var entries: [Entry] = []
    // Shared Instance for Container
    let privateDB = CKContainer.default().privateCloudDatabase
    
    
    
    // MARK: - CRUD Methods
    
    // Create
    func createEntry(with title: String, with body: String, with timestamp: Date, completion: @escaping (Result<Entry?, EntryError>) -> Void) {
        
        // Creates a new entry
        let newEntry = Entry(title: title, body: body)
        
        saveEntry(entry: newEntry) { (result) in
            switch result {
            case .success(let entry):
                completion(.success(entry))
                print("✅ WE HAVE MADE IT TO THE CLOUD!!!!")
            case .failure(let error):
                completion(.failure(.ckError(error)))
                print("❌\(error.localizedDescription)")
            }
        }
        
    } // END OF FUNC
    
    func saveEntry(entry: Entry, completion: @escaping(Result<Entry?, EntryError>) -> Void) {
        // Gets the entry and converts it into a CKRecord
        let entryRecord = CKRecord(entry: entry)
        // Now that we have a converted record, we can save it to our private DB.
        self.privateDB.save(entryRecord) { (record, error) in
            if let error = error {
                print("""
                ========= ERROR =========
                Function: \(#function)
                Error: \(error)
                Description: \(error.localizedDescription)
                ========= ERROR =========
                """)
                return completion(.failure(.ckError(error)))
            }
            // Now we guard the record
            guard let record = record,
                  // Also guard our Entry that is now of type record, and declare it as a savedEntry
                  let savedEntry = Entry(ckRecord: record) else { return completion(.failure(.unableToUnwrap)) }
            // Enters the empty entries array, our source of truth, and adds the saved entry to the array.
            self.entries.append(savedEntry)
            // Upon success, we complete (saving the data to the private DB) with our savedEntry.
            return completion(.success(savedEntry))
        }
        
    }
    
    // Read
    func fetchEntriesWith(completion: @escaping(Result<[Entry]?, EntryError>) -> Void) {
        let fetchAllPredicate = NSPredicate(value: true)
        let entryQuery = CKQuery(recordType: EntryConstants.recordTypeKey, predicate: fetchAllPredicate)
        
        CKContainer.default().privateCloudDatabase.perform(entryQuery, inZoneWith: nil) { (records, error) in
            if let error = error {
                print("""
                ========= ERROR =========
                Function: \(#function)
                Error: \(error)
                Description: \(error.localizedDescription)
                ========= ERROR =========
                """)
                
                return completion(.failure(.ckError(error)))
            }
            
            guard let records = records else { return completion(.failure(.unableToUnwrap)) }
            
            let fetchedEntries = records.compactMap { Entry(ckRecord: $0) }
            self.entries = fetchedEntries
            
            print("Succesfully fetched entries.")
            return completion(.success(fetchedEntries))
            
        }
    }
    
    // Update
    func updateEntry(entry: Entry, title: String, body: String, completion: @escaping(Result<String, EntryError>) -> Void) {
//        entry.title = title
//        entry.body = body
        
        privateDB.fetch(withRecordID: entry.ckRecordID) { (record, error) in
            if let error = error {
                print("""
                ========= ERROR =========
                Function: \(#function)
                Error: \(error)
                Description: \(error.localizedDescription)
                ========= ERROR =========
                """)
            }
            
            if let recordToSave = record {
                recordToSave.setValue(title, forKey: EntryConstants.titleKey)
                recordToSave.setValue(body, forKey: EntryConstants.bodyKey)
                
                let modifyRecord = CKModifyRecordsOperation(recordsToSave: [recordToSave], recordIDsToDelete: nil)
                modifyRecord.savePolicy = CKModifyRecordsOperation.RecordSavePolicy.changedKeys
                self.privateDB.add(modifyRecord)
                completion(.success("updated"))
            }
        }
    }
    
    func delete(entry: Entry, completion: @escaping (Result<String, EntryError>) -> Void) {
        let ckRecord = CKRecord(entry: entry)
        privateDB.delete(withRecordID: ckRecord.recordID) { (_, error) in
            DispatchQueue.main.async {
                if let error = error {
                    print("""
                ========= ERROR =========
                Function: \(#function)
                Error: \(error)
                Description: \(error.localizedDescription)
                ========= ERROR =========
                """)
                    return completion(.failure(.ckError(error)))
                }
                
                guard let index = self.entries.firstIndex(of: entry) else { return completion(.failure(.unableToUnwrap)) }
                self.entries.remove(at: index)
                completion(.success("Sucessfully deleted"))
            }
        }
    }
    
} // END OF CLASS

