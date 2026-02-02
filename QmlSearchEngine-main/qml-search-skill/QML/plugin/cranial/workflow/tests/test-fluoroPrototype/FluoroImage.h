#ifndef FLUOROIMAGE_H
#define FLUOROIMAGE_H

#include <QObject>
#include <QImage>
#include <QMatrix4x4>
#include <QVector2D>
#include <QVector3D>
#include <algorithms/GmLine.h>

#include <fluororegistration/FluoroRegistration.h>

const unsigned int NUMBER_RING_CNTR_PNTS = 5;

class FluoroImage : public QObject
{
    Q_OBJECT
public:
    explicit FluoroImage(QObject *parent = 0);
    ~FluoroImage();

    void load(const QString &imgF, const QString &setF);

    QString uuid() const { return m_uuid; }
    QImage image() const { return m_image; }


signals:
    void ringsChanged();

public slots:
    void imgToFixture(const QVector2D &imgPt, GmLine &fixLine);
    QVariantList imgToFixture(const QVector2D &pImg);
    QVector2D fixtureToImg(const QVector3D &pnt);

    QVariantList ringEllipse(int ring);
    QVariantList fidLandmarks_fig() const { return mFidLandmarks_fig; }

    void calculateRingRegistration();
    void setRingControlPnt(int ring, int idx, const QVector2D pnt);
    QVector2D ringControlPnt(int ring,int idx) const { return m_ringControlPnts_img.at(ring*NUMBER_RING_CNTR_PNTS+idx); }

    QString fixtureUuid() const { return m_fixtureUuid; }

    void captureFixtureXdrb();


    QVariantList genericLandmarks() const { return m_genericLandmarks; }
    QString landmarksRomUuid() const { return m_landmarksRomUuid; }

private:
    void updateRings();
    void updateTransformManager();

    QString m_uuid;
    QImage m_image;
    QString m_settingsFile;

    QVector < QVector2D > m_ringControlPnts_img;

    QMatrix4x4 m_wFixture1_T_img;
    QMatrix4x4 m_wFixture2_T_img;

    QMatrix4x4 m_img_T_fixture;

    FluoroRegistration *m_fluoroReg;

    QVariantList mFidLandmarks_fig;

    QString m_fixtureUuid;
    QString m_drbUuid;

    //
    QString m_landmarksRomUuid;
    QVariantList m_genericLandmarks;
};

#endif // FLUOROIMAGE_H
