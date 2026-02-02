#pragma once

#include <gm/util/qml/enum.h>

namespace ehubsettings::types {

GM_Q_ENUM(HeadsetFeedType, (HeadsetA_Stereo = 0)(HeadsetB_Stereo = 1)(Unknown = 2))

inline QString to_string(HeadsetFeedType type)
{
    switch (type)
    {
    case HeadsetFeedType::HeadsetA_Stereo: return "Headset A";
    case HeadsetFeedType::HeadsetB_Stereo: return "Headset B";
    case HeadsetFeedType::Unknown: return "Unknown";
    }
}

inline HeadsetFeedType to_headsetFeedType(QString headsetFeedType)
{
    if (headsetFeedType == "Headset A")
        return HeadsetFeedType::HeadsetA_Stereo;
    else if (headsetFeedType == "Headset B")
        return HeadsetFeedType::HeadsetB_Stereo;

    return HeadsetFeedType::Unknown;
}
}  // namespace ehubsettings::types

Q_DECLARE_METATYPE(ehubsettings::types::HeadsetFeedType)
