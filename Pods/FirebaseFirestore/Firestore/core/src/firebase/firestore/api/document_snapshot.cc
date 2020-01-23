/*
 * Copyright 2019 Google
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

#include "Firestore/core/src/firebase/firestore/api/document_snapshot.h"

#include "Firestore/core/src/firebase/firestore/api/document_reference.h"
#include "Firestore/core/src/firebase/firestore/model/field_value.h"
#include "Firestore/core/src/firebase/firestore/objc/objc_compatibility.h"
#include "Firestore/core/src/firebase/firestore/util/hashing.h"
#include "absl/types/optional.h"

namespace firebase {
namespace firestore {
namespace api {

using model::Document;
using model::DocumentKey;
using model::FieldPath;
using model::FieldValue;
using model::ObjectValue;
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/api/document_snapshot.cc

DocumentSnapshot DocumentSnapshot::FromDocument(
    std::shared_ptr<Firestore> firestore,
    model::Document document,
    SnapshotMetadata metadata) {
  return DocumentSnapshot{std::move(firestore), document.key(), document,
                          std::move(metadata)};
}

DocumentSnapshot DocumentSnapshot::FromNoDocument(
    std::shared_ptr<Firestore> firestore,
    model::DocumentKey key,
    SnapshotMetadata metadata) {
  return DocumentSnapshot{std::move(firestore), key, absl::nullopt,
                          std::move(metadata)};
=======

DocumentSnapshot::DocumentSnapshot(std::shared_ptr<Firestore> firestore,
                                   model::DocumentKey document_key,
                                   absl::optional<Document> document,
                                   SnapshotMetadata metadata)
    : firestore_{std::move(firestore)},
      internal_key_{std::move(document_key)},
      internal_document_{std::move(document)},
      metadata_{std::move(metadata)} {
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/api/document_snapshot.cc
}

DocumentSnapshot::DocumentSnapshot(std::shared_ptr<Firestore> firestore,
                                   model::DocumentKey document_key,
                                   absl::optional<Document> document,
<<<<<<< HEAD:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/api/document_snapshot.cc
                                   SnapshotMetadata metadata)
    : firestore_{std::move(firestore)},
      internal_key_{std::move(document_key)},
      internal_document_{std::move(document)},
      metadata_{std::move(metadata)} {
=======
                                   bool from_cache,
                                   bool has_pending_writes)
    : firestore_{std::move(firestore)},
      internal_key_{std::move(document_key)},
      internal_document_{std::move(document)},
      metadata_{has_pending_writes, from_cache} {
>>>>>>> 85cdc9998299efb8f2313da5d774f217a2cbce0d:Pods/FirebaseFirestore/Firestore/core/src/firebase/firestore/api/document_snapshot.cc
}

size_t DocumentSnapshot::Hash() const {
  return util::Hash(firestore_.get(), internal_key_, internal_document_,
                    metadata_);
}

bool DocumentSnapshot::exists() const {
  return internal_document_.has_value();
}

const absl::optional<Document>& DocumentSnapshot::internal_document() const {
  return internal_document_;
}

DocumentReference DocumentSnapshot::CreateReference() const {
  return DocumentReference{internal_key_, firestore_};
}

const std::string& DocumentSnapshot::document_id() const {
  return internal_key_.path().last_segment();
}

absl::optional<ObjectValue> DocumentSnapshot::GetData() const {
  return internal_document_ ? internal_document_->data()
                            : absl::optional<ObjectValue>{};
}

absl::optional<FieldValue> DocumentSnapshot::GetValue(
    const FieldPath& field_path) const {
  return internal_document_ ? internal_document_->field(field_path)
                            : absl::optional<ObjectValue>{};
}

bool operator==(const DocumentSnapshot& lhs, const DocumentSnapshot& rhs) {
  return lhs.firestore_ == rhs.firestore_ &&
         lhs.internal_key_ == rhs.internal_key_ &&
         lhs.internal_document_ == rhs.internal_document_ &&
         lhs.metadata_ == rhs.metadata_;
}

}  // namespace api
}  // namespace firestore
}  // namespace firebase
