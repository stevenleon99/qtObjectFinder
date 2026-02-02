#include "HeadsetFeedProvider.h"

#include <com/headset/HeadsetFeedVisualizer.h>
#include <gos/video/VideoFeedProxyFactory.h>
#include <service/glink/node/INode.h>
#include <sys/log/sys_log.h>

namespace ehubsettings::imageprovider {

using namespace gos::itf::video;
using namespace ehubsettings::types;

HeadsetFeedProvider::HeadsetFeedProvider(std::shared_ptr<glink::node::INode> node, QObject* parent)
    : QObject(parent)
    , QQuickImageProvider(QQmlImageProviderBase::Image)
    , m_node(node)
{
    std::vector<std::string> tags = {"ARight", "ALeft", "BRight", "BLeft"};

    for (size_t i = 0; i < tags.size(); i++)
    {
        m_videoFeeds.insert(
            {tags[i],
             new com::headset::HeadsetFeedVisualizer(
                 gos::video::VideoFeedProxyFactory::createInstance(tags[i], m_node), this)});
    }

    selectFeed(HeadsetFeedType::Unknown);
}

QImage HeadsetFeedProvider::requestImage(const QString& id, QSize* size, const QSize& requestedSize)
{
    // id is stream index + frame
    auto&& feeds = getVideoFeeds(m_activeHeadsetFeedType);
    QStringList parts = id.split('/');
    QString firstPart = parts.first();
    int streamIndex = firstPart.toInt();
    if (streamIndex < 0 || streamIndex >= feeds.size())
    {
        SYS_LOG_ERROR("Headset feed requesting invalid stream index: {}", streamIndex);
        return QImage();
    }
    return feeds[streamIndex]->requestImage(id, size, requestedSize);
}

void HeadsetFeedProvider::selectFeed(HeadsetFeedType feedType)
{
    m_activeHeadsetFeedType = feedType;
    for (const auto& [_, feed] : m_videoFeeds)
    {
        feed->setEnabled(getVideoFeeds(feedType).contains(feed));
    }
}

QList<com::headset::HeadsetFeedVisualizer*> HeadsetFeedProvider::getVideoFeeds(
    HeadsetFeedType feedType)
{
    QList<com::headset::HeadsetFeedVisualizer*> feeds;
    switch (feedType)
    {
    case HeadsetFeedType::HeadsetA_Stereo:
        return feeds << m_videoFeeds["ALeft"] << m_videoFeeds["ARight"];
    case HeadsetFeedType::HeadsetB_Stereo:
        return feeds << m_videoFeeds["BLeft"] << m_videoFeeds["BRight"];
    default: return feeds;
    }
}

QVariantList convertToVariantList(const QList<com::headset::HeadsetFeedVisualizer*>& list)
{
    QVariantList variantList;
    for (com::headset::HeadsetFeedVisualizer* item : list)
    {
        variantList << QVariant::fromValue(item);
    }
    return variantList;
}

QVariantList HeadsetFeedProvider::getVideoFeedsVariantList(HeadsetFeedType feedType)
{
    return convertToVariantList(getVideoFeeds(feedType));
}

}  // namespace ehubsettings::imageprovider
