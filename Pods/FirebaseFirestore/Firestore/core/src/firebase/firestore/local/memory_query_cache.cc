/*
 * Copyright 2018 Google
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "Firestore/core/src/firebase/firestore/local/memory_query_cache.h"

#include <vector>

#include "Firestore/core/src/firebase/firestore/local/memory_persistence.h"
#include "Firestore/core/src/firebase/firestore/local/query_data.h"
#include "Firestore/core/src/firebase/firestore/local/reference_delegate.h"
#include "Firestore/core/src/firebase/firestore/local/sizer.h"
#include "Firestore/core/src/firebase/firestore/model/document_key.h"

namespace firebase {
namespace firestore {
namespace local {

<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
using core::Target;
=======
using core::Query;
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
using model::DocumentKey;
using model::DocumentKeySet;
using model::ListenSequenceNumber;
using model::SnapshotVersion;
using model::TargetId;

MemoryQueryCache::MemoryQueryCache(MemoryPersistence* persistence)
    : persistence_(persistence),
      highest_listen_sequence_number_(ListenSequenceNumber(0)),
      highest_target_id_(TargetId(0)),
      last_remote_snapshot_version_(SnapshotVersion::None()),
      targets_() {
}

void MemoryQueryCache::AddTarget(const QueryData& query_data) {
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
  targets_[query_data.target()] = query_data;
=======
  queries_[query_data.query()] = query_data;
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
  if (query_data.target_id() > highest_target_id_) {
    highest_target_id_ = query_data.target_id();
  }
  if (query_data.sequence_number() > highest_listen_sequence_number_) {
    highest_listen_sequence_number_ = query_data.sequence_number();
  }
}

void MemoryQueryCache::UpdateTarget(const QueryData& query_data) {
  // For the memory query cache, adds and updates are treated the same.
  AddTarget(query_data);
}

void MemoryQueryCache::RemoveTarget(const QueryData& query_data) {
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
  targets_.erase(query_data.target());
  references_.RemoveReferences(query_data.target_id());
}

absl::optional<QueryData> MemoryQueryCache::GetTarget(const Target& target) {
  auto iter = targets_.find(target);
  return iter == targets_.end() ? absl::optional<QueryData>{} : iter->second;
=======
  queries_.erase(query_data.query());
  references_.RemoveReferences(query_data.target_id());
}

absl::optional<QueryData> MemoryQueryCache::GetTarget(const Query& query) {
  auto iter = queries_.find(query);
  return iter == queries_.end() ? absl::optional<QueryData>{} : iter->second;
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
}

void MemoryQueryCache::EnumerateTargets(const TargetCallback& callback) {
  for (const auto& kv : targets_) {
    callback(kv.second);
  }
}

int MemoryQueryCache::RemoveTargets(
    model::ListenSequenceNumber upper_bound,
    const std::unordered_map<TargetId, QueryData>& live_targets) {
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
  std::vector<const Target*> to_remove;
  for (const auto& kv : targets_) {
    const Target& target = kv.first;
=======
  std::vector<const Query*> to_remove;
  for (const auto& kv : queries_) {
    const Query& query = kv.first;
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
    const QueryData& query_data = kv.second;

    if (query_data.sequence_number() <= upper_bound) {
      if (live_targets.find(query_data.target_id()) == live_targets.end()) {
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
        to_remove.push_back(&target);
=======
        to_remove.push_back(&query);
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
        references_.RemoveReferences(query_data.target_id());
      }
    }
  }

<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
  for (const Target* element : to_remove) {
    targets_.erase(*element);
=======
  for (const Query* element : to_remove) {
    queries_.erase(*element);
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
  }
  return static_cast<int>(to_remove.size());
}

void MemoryQueryCache::AddMatchingKeys(const DocumentKeySet& keys,
                                       TargetId target_id) {
  references_.AddReferences(keys, target_id);
  for (const DocumentKey& key : keys) {
    persistence_->reference_delegate()->AddReference(key);
  }
}

void MemoryQueryCache::RemoveMatchingKeys(const DocumentKeySet& keys,
                                          TargetId target_id) {
  references_.RemoveReferences(keys, target_id);
  for (const DocumentKey& key : keys) {
    persistence_->reference_delegate()->RemoveReference(key);
  }
}

DocumentKeySet MemoryQueryCache::GetMatchingKeys(TargetId target_id) {
  return references_.ReferencedKeys(target_id);
}

bool MemoryQueryCache::Contains(const DocumentKey& key) {
  return references_.ContainsKey(key);
}

int64_t MemoryQueryCache::CalculateByteSize(const Sizer& sizer) {
  int64_t count = 0;
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.cc
  for (const auto& kv : targets_) {
=======
  for (const auto& kv : queries_) {
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/local/memory_query_cache.mm
    count += sizer.CalculateByteSize(kv.second);
  }
  return count;
}

const SnapshotVersion& MemoryQueryCache::GetLastRemoteSnapshotVersion() const {
  return last_remote_snapshot_version_;
}

void MemoryQueryCache::SetLastRemoteSnapshotVersion(SnapshotVersion version) {
  last_remote_snapshot_version_ = std::move(version);
}

}  // namespace local
}  // namespace firestore
}  // namespace firebase
