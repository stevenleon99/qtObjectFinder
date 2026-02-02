/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#ifndef Q_MOC_RUN
#include <filesystem>
#endif

namespace drive::viewmodel {

constexpr char SCREENSHOTS_DIR[] = "screenshots";
constexpr char SCREENSHOTS_EXTN[] = ".png";

inline std::filesystem::path screenshotPersistenceDir(
    const std::filesystem::path& basePath,
    std::string_view name = SCREENSHOTS_DIR)
{
    return basePath / std::string(name);
}

inline std::filesystem::path screenshotFile(
    const std::filesystem::path& path,
    std::string_view name,
    std::string_view extn = SCREENSHOTS_EXTN)
{
    return path / (std::string(name) + std::string(extn));
}

}  // namespace drive::viewmodel
