#include "OnboardingTutorialViewModel.h"

#include <QApplication>
#include <QDir>

namespace drive::viewmodel {

constexpr char TUTORIAL_DIR_NAME[] = "images/tutorial";

OnboardingTutorialViewModel::OnboardingTutorialViewModel(QObject* parent)
    : QObject(parent)
    , m_imageInfoListModel{std::make_shared<ImageInfoListModel>()}
{
    loadImageInfoList(qApp->applicationDirPath() + "/" + TUTORIAL_DIR_NAME);
}

void OnboardingTutorialViewModel::loadImageInfoList(const QString& dirPath)
{
    QDir dir(dirPath);

    // Set file name filters for image types
    QStringList nameFilters;
    nameFilters << "*.jpg"
                << "*.jpeg"
                << "*.png";

    // Retrieve the list of files sort by name in ascending order
    QStringList imageFiles =
        dir.entryList(nameFilters, QDir::Files, QDir::Name);

    ImageInfoList imageInfoList;
    for (int i = 0; i < imageFiles.size(); ++i)
    {
        ImageInfoItem imageInfoItem{dirPath + "/" + imageFiles[i]};
        imageInfoList[i] = imageInfoItem;
    }

    m_imageInfoListModel->update(imageInfoList);
}

}  // namespace drive::viewmodel
