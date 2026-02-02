#pragma once

#include "HeadsetFeedTypes.h"

#ifndef Q_MOC_RUN
#include <memory>
#endif

#include <QQuickImageProvider>

namespace glink::node {
struct INode;
}

namespace com::headset {
class HeadsetFeedVisualizer;
}

namespace ehubsettings::imageprovider {

/**
 * @brief The HeadsetFeedProvider class manages to HeadsetFeedVisualizers
 * and provides the requested headset feed and connection statuses.
 */
class HeadsetFeedProvider : public QObject, public QQuickImageProvider
{
    Q_OBJECT

public:
    HeadsetFeedProvider(std::shared_ptr<glink::node::INode> node, QObject* parent = nullptr);

    QImage requestImage(const QString& id, QSize* size, const QSize& requestedSize) override;

    QVariantList getVideoFeedsVariantList(ehubsettings::types::HeadsetFeedType feedType);

public slots:
    void selectFeed(ehubsettings::types::HeadsetFeedType feedType);

private:
    QList<com::headset::HeadsetFeedVisualizer*> getVideoFeeds(
        ehubsettings::types::HeadsetFeedType feedType);

    std::map<std::string, com::headset::HeadsetFeedVisualizer*, std::less<>> m_videoFeeds;

    std::shared_ptr<glink::node::INode> m_node;
    bool m_connected{false};

    ehubsettings::types::HeadsetFeedType m_activeHeadsetFeedType;
};

}  // namespace ehubsettings::imageprovider
