#pragma once

#ifndef Q_MOC_RUN
#include <gm/util/qml/MapListModel.h>
#include <lager/extra/struct.hpp>
#endif

namespace drive::viewmodel {

struct ImageInfoItem
{
    QString path;

    LAGER_STRUCT_NESTED(ImageInfoItem, path);
};

using ImageInfoList = std::map<int, ImageInfoItem>;
using ImageInfoListModel = gm::util::qml::MapListModel<ImageInfoList>;

class OnboardingTutorialViewModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QAbstractListModel* imageList READ imageInfoList CONSTANT)

public:
    OnboardingTutorialViewModel(QObject* parent = nullptr);

    QAbstractListModel* imageInfoList() const
    {
        return m_imageInfoListModel->abstractListModel();
    }

private:
    void loadImageInfoList(const QString& dirPath);

    std::shared_ptr<ImageInfoListModel> m_imageInfoListModel;
};

}  // namespace drive::viewmodel
