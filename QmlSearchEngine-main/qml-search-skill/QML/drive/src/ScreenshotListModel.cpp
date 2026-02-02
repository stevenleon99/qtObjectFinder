/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#include "ScreenshotListModel.h"
#include <drive/common/DriveCommon.h>

namespace drive::viewmodel {

using namespace drive::com::propertysource;

ScreenshotListModel::ScreenshotListModel(QObject* parent)
    : QAbstractListModel(parent)
{}

QHash<int, QByteArray> ScreenshotListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[ScreenshotIdStr] = "role_screenshot_id";
    roles[ScreenshotPath] = "role_path";
    roles[CapturedDate] = "role_date";
    return roles;
}

int ScreenshotListModel::rowCount(const QModelIndex&) const
{
    return static_cast<int>(m_screenshotList.size());
}

QVariant ScreenshotListModel::data(const QModelIndex& index, int role) const
{
    std::size_t rowIndex = index.row();
    if (rowIndex < 0 || rowIndex >= m_screenshotList.size())
        return QVariant();

    auto const& screenshot = m_screenshotList.at(index.row());

    switch (role)
    {
    case ScreenshotIdStr: return screenshot.first;
    case ScreenshotPath:
        return QString::fromStdString(
            m_screenshotPath(screenshot.first).string());
    case CapturedDate:
        return drive::common::formatDateTime(screenshot.second,
                                             drive::common::TIME_FORMAT);
    default: return QVariant();
    }
}

int ScreenshotListModel::count() const
{
    return static_cast<int>(m_screenshotList.size());
}

void ScreenshotListModel::setScreenshotList(
    const ScreenshotList& screenshotList, PathLocator locator)
{
    m_screenshotPath = std::move(locator);

    auto [added, removed] = screenshotDiff(screenshotList, m_screenshotList);

    for (auto const& addedItem : added)
    {
        beginInsertRows(QModelIndex(),
                        static_cast<int>(m_screenshotList.size()),
                        static_cast<int>(m_screenshotList.size()));
        m_screenshotList.push_back(addedItem);
        endInsertRows();
    }

    for (auto const& removedItem : removed)
    {
        auto itr = std::find(m_screenshotList.begin(), m_screenshotList.end(),
                             removedItem);
        if (itr != m_screenshotList.end())
        {
            auto itrIndex =
                static_cast<int>(std::distance(m_screenshotList.begin(), itr));
            beginRemoveRows(QModelIndex(), itrIndex, itrIndex);
            m_screenshotList.erase(itr);
            endRemoveRows();
        }
    }

    Q_EMIT countChanged();
}

std::pair<ScreenshotListModel::ScreenshotList,
          ScreenshotListModel::ScreenshotList>
ScreenshotListModel::screenshotDiff(ScreenshotList left, ScreenshotList right)
{
    auto comp = [](const ScreenshotDetails& left_,
                   const ScreenshotDetails& right_) {
        return left_.first < right_.first;
    };

    std::sort(left.begin(), left.end(), comp);
    std::sort(right.begin(), right.end(), comp);

    ScreenshotList added, removed;
    std::set_difference(left.begin(), left.end(), right.begin(), right.end(),
                        std::inserter(added, added.begin()));
    std::set_difference(right.begin(), right.end(), left.begin(), left.end(),
                        std::inserter(removed, removed.begin()));
    return std::pair{added, removed};
}

}  // namespace drive::viewmodel
