/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */
#pragma once

#include <drive/model/datamodel/model.h>
#include <drive/model/common/serialization.h>
#include <gm/util/qt/typeconv/qstring_conv.h>

namespace drive::util {
using gm::util::typeconv::convert;

using CaseIdentifier = ::drive::model::CaseIdentifier;

constexpr char WORKFLOW_BEGIN_PREFIX[] = "Begin Workflow Case for ";
constexpr char WORKFLOW_END_PREFIX[] = "End Workflow Case for ";

inline QString workflowBeginMessage(CaseIdentifier id)
{
    return WORKFLOW_BEGIN_PREFIX +
           convert<QString>(drive::model::id_to_string(id));
}

inline QString workflowEndMessage(CaseIdentifier id)
{
    return WORKFLOW_END_PREFIX +
           convert<QString>(drive::model::id_to_string(id));
}

inline std::string workflowBeginMessage(QString const& id)
{
    return WORKFLOW_BEGIN_PREFIX + convert<std::string>(id);
}

inline std::string workflowEndMessage(QString const& id)
{
    return WORKFLOW_END_PREFIX + convert<std::string>(id);
}

}  // namespace drive::util
