#ifndef EVENTMODEL_H
#define EVENTMODEL_H

#include <QObject>
#include <QDateTime>
#include <QMap>
#include <QMatrix4x4>
#include <QByteArray>
#include <QImage>

class EventData {
public:
    QDateTime m_datetime;
    QString m_event;
    QString m_dataType;
    QString m_scanUuid;
    QString m_stringData;
    QByteArray m_data;

    QMap<QString, QMatrix4x4> m_cameraXtool;
};

class FluoroCapture: public EventData {
public:
    QString m_uuid;
    QString m_index;
    QImage m_Image;
    QMatrix4x4 m_fluoroTracker_X_Drb;
};

class EventModel : public QObject
{
    Q_OBJECT
public:
    explicit EventModel(QObject *parent = 0);


    void loadEvents();

    void fluoroAccuracy();

    QStringList toolList() const;
signals:

public slots:

private:
    QList <EventData> m_events;
    QMap<QString, QMatrix4x4> activeTrackers(const QByteArray &json);

    QString studyKey(const QString &scanUuid);
    QVector3D toolTip(const QString &toolUuid);
    void updateFluoroTransforms(const QString scanUuid, const QString drbUuid, const QString fluoroTrackerUuid, const QMatrix4x4 &image_X_Fixture, const QMatrix4x4 &fluoroTracker_X_drb, const QMatrix4x4 &fixture_X_Image_1, const QMatrix4x4 &fixture_X_Image_2);
    bool updateTransformWithAlgorithm(const QString studyUuid, const QString scanUuid[], const QString &fluoroTrackerUuid, const QString &drbUuid, const QMap<QString, QMatrix4x4> &fluoroTracker_X_DrbMap);
    bool updateTransformWithPickedPnts(const QString studyUuid, const QString scanUuid[], const QString &fluoroTrackerUuid, const QString &drbUuid, const QMap<QString, QMatrix4x4> &fluoroTracker_X_DrbMap);
};

#endif // EVENTMODEL_H
