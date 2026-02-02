#ifndef FLUOROMANAGER_H
#define FLUOROMANAGER_H

#include <QObject>
#include <QQuickImageProvider>
#include <QMap>
#include "FluoroImage.h"
#include "FluoroScrew.h"

class FluoroManager : public QObject, public QQuickImageProvider
{
    Q_OBJECT
    Q_PROPERTY(QVector2D bodyPosteriorLatImg READ bodyPosteriorLatImg WRITE setBodyPosteriorLatImg NOTIFY pointsChanged)
    Q_PROPERTY(QVector2D bodyAnteriorLatImg READ bodyAnteriorLatImg WRITE setBodyAnteriorLatImg NOTIFY pointsChanged)

    Q_PROPERTY(QVector2D pedicleAinside READ pedicleAinside WRITE setPedicleAinside NOTIFY pointsChanged)
    Q_PROPERTY(QVector2D pedicleBinside READ pedicleBinside WRITE setPedicleBinside NOTIFY pointsChanged)

    Q_PROPERTY(float pedicleAwidth READ pedicleAwidth WRITE setPedicleAwidth NOTIFY pointsChanged)
    Q_PROPERTY(float pedicleBwidth READ pedicleBwidth WRITE setPedicleBwidth NOTIFY pointsChanged)

    Q_PROPERTY(QVector3D tipA READ tipA WRITE setTipA NOTIFY pointsChanged)
    Q_PROPERTY(QVector3D headA READ headA WRITE setHeadA NOTIFY pointsChanged)

    Q_PROPERTY(QVector3D tipB READ tipB WRITE setTipB NOTIFY pointsChanged)
    Q_PROPERTY(QVector3D headB READ headB WRITE setHeadB NOTIFY pointsChanged)



    Q_PROPERTY(bool screwAactive READ screwAactive WRITE setScrewAactive NOTIFY pointsChanged)

public:
    explicit FluoroManager(QObject *parent = 0);
    ~FluoroManager();

    virtual QImage requestImage(const QString & id, QSize * size, const QSize & requestedSize);

    void registerImage(FluoroImage *fImg);

    QVector2D bodyPosteriorLatImg() const { return m_bodyPosterior_latImg; }
    QVector2D bodyAnteriorLatImg() const { return m_bodyAnterior_latImg; }

    QVector2D pedicleAinside() const { return m_pedicleAinside_apImg; }
    QVector2D pedicleBinside() const { return m_pedicleBinside_apImg; }

    float pedicleAwidth() const { return m_pedicleAwidth_apImg; }
    float pedicleBwidth() const { return m_pedicleBwidth_apImg; }

    QVector3D tipA() const { return m_pTip_A; }
    QVector3D headA() const { return m_pHead_A; }

    QVector3D tipB() const { return m_pTip_B; }
    QVector3D headB() const { return m_pHead_B; }

    bool cursor() const { return m_cursor; }
    bool screwAactive() const { return m_screwAactive; }

    void initialize();
signals:
    void pointsChanged();
    void cursorPosition(const QString &uuid, const QVector3D &ptA, const QVector3D &ptB);
    void registrationChanged(const QVariantList &regList);

public slots:
    void mousePositionChanged(const QString &uuid, const QVector2D &pt);
    void mousePressed(const QString &uuid, const QVector2D &pt, float imageScale);

    void setBodyPosteriorLatImg(const QVector2D &p);
    void setBodyAnteriorLatImg(const QVector2D &p);

    void setPedicleAinside(const QVector2D &p);
    void setPedicleAwidth(float d);

    void setPedicleBinside(const QVector2D &p);
    void setPedicleBwidth(float d);

    void setTipA(const QVector3D &p);
    void setHeadA(const QVector3D &p);
    void setTipB(const QVector3D &p);
    void setHeadB(const QVector3D &p);

    void setScrewAactive(bool s);


    void autoScrewPlacement();
    void update();

    void computeRegistration();

    QVector3D closestPointOnLineAfromLineB( QVector3D lineAp0, QVector3D  lineAp1,QVector3D lineBp0, QVector3D  lineBp1);


    QObject *image(const QString &uuid) { return m_fluoroImages.contains(uuid) ? m_fluoroImages[uuid] : 0; }

private:
    QMap< QString, FluoroImage *> m_fluoroImages;
    QMap< QString, FluoroScrew *> m_fluoroScrews;

    QVector2D m_bodyPosterior_latImg;
    QVector2D m_bodyAnterior_latImg;

    QVector2D m_pedicleAinside_apImg;
    QVector2D m_pedicleBinside_apImg;
    float m_pedicleAwidth_apImg;
    float m_pedicleBwidth_apImg;

    QVector3D m_pTip_A;
    QVector3D m_pHead_A;

    QVector3D m_pTip_B;
    QVector3D m_pHead_B;

    bool m_cursor;
    bool m_screwAactive;

    QVariantList m_RegPnts;
};

#endif // FLUOROMANAGER_H
