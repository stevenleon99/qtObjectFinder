/* Copyright (c) Globus Medical, Inc. - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 */

#pragma once

#include <drive/com/propertysource/CaseSummaryPropertySource.h>

#include <QAbstractListModel>

#ifndef Q_MOC_RUN
#include <filesystem>
#include <gm/util/functional/function.h>
#endif

namespace drive::viewmodel {

using PathLocator =
    gm::util::functional::Function<std::filesystem::path(QString const&)>;

class ScreenshotListModel : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(int count READ count NOTIFY countChanged)

    using ScreenshotList =
        std::vector<drive::com::propertysource::ScreenshotDetails>;

public:
    enum RoleNames
    {
        ScreenshotIdStr = Qt::UserRole + 1,
        ScreenshotPath,
        CapturedDate
    };

    ScreenshotListModel(QObject* parent = nullptr);

    QHash<int, QByteArray> roleNames() const override;
    int rowCount(const QModelIndex& parent) const override;
    QVariant data(const QModelIndex& index, int role) const override;
    int count() const;

    void setScreenshotList(const ScreenshotList& screenshotList,
                           PathLocator locator);

signals:
    void countChanged();

private:
    std::pair<ScreenshotList, ScreenshotList> screenshotDiff(
        ScreenshotList left, ScreenshotList right);

    ScreenshotList m_screenshotList;
    PathLocator m_screenshotPath;
};

}  // namespace drive::viewmodel
