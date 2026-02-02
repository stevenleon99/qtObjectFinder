#include "FluoroManager.h"
#include <QPoint>

FluoroManager::FluoroManager(QObject* parent)
    : QObject(parent)
    , QQuickImageProvider(QQmlImageProviderBase::Image)
    , m_bodyPosterior_latImg(40, 0)
    , m_bodyAnterior_latImg(-20, 0)
    , m_pedicleAinside_apImg(20, 0)
    , m_pedicleAwidth_apImg(60)
    , m_pedicleBinside_apImg(-20, 0)
    , m_pedicleBwidth_apImg(60)
    , m_cursor(false)
    , m_screwAactive(true)
{
    connect(this, &FluoroManager::pointsChanged, this,
            &FluoroManager::computeRegistration);
}

FluoroManager::~FluoroManager() {}

void FluoroManager::registerImage(FluoroImage* fImg)
{
    m_fluoroImages[fImg->uuid()] = fImg;
}

void FluoroManager::setBodyPosteriorLatImg(const QVector2D& p)
{
    if (!qFuzzyCompare(p, m_bodyPosterior_latImg))
    {
        m_bodyPosterior_latImg = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setBodyAnteriorLatImg(const QVector2D& p)
{
    if (!qFuzzyCompare(p, m_bodyAnterior_latImg))
    {
        m_bodyAnterior_latImg = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setPedicleAinside(const QVector2D& p)
{
    if (!qFuzzyCompare(p, m_pedicleAinside_apImg))
    {
        m_pedicleAinside_apImg = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setPedicleBinside(const QVector2D& p)
{
    if (!qFuzzyCompare(p, m_pedicleBinside_apImg))
    {
        m_pedicleBinside_apImg = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setPedicleAwidth(float d)
{
    if (!qFuzzyCompare(d, m_pedicleAwidth_apImg))
    {
        m_pedicleAwidth_apImg = d;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setPedicleBwidth(float d)
{
    if (!qFuzzyCompare(d, m_pedicleBwidth_apImg))
    {
        m_pedicleBwidth_apImg = d;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setTipA(const QVector3D& p)
{
    if (!qFuzzyCompare(p, m_pTip_A))
    {
        m_pTip_A = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setHeadA(const QVector3D& p)
{
    if (!qFuzzyCompare(p, m_pHead_A))
    {
        m_pHead_A = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setTipB(const QVector3D& p)
{
    if (!qFuzzyCompare(p, m_pTip_B))
    {
        m_pTip_B = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setHeadB(const QVector3D& p)
{
    if (!qFuzzyCompare(p, m_pHead_B))
    {
        m_pHead_B = p;
        Q_EMIT pointsChanged();
    }
}

void FluoroManager::setScrewAactive(bool s)
{
    if (m_screwAactive != s)
    {
        m_screwAactive = s;
        Q_EMIT pointsChanged();
    }
}

QImage FluoroManager::requestImage(const QString& id,
                                   QSize* /*size*/,
                                   const QSize& /*requestedSize*/)
{
    if (!id.isEmpty())
    {
        QString fuuid = id;

        if (m_fluoroImages.contains(fuuid))
            return m_fluoroImages[fuuid]->image();
    }

    return QImage();
}

void FluoroManager::mousePressed(const QString& uuid,
                                 const QVector2D& pt,
                                 float imageScale)
{
    Q_UNUSED(uuid)
    Q_UNUSED(pt)
    Q_UNUSED(imageScale)
}

void FluoroManager::mousePositionChanged(const QString& uuid,
                                         const QVector2D& pt)
{
    if (m_fluoroImages.contains(uuid))
    {
        GmLine cursorLine;
        m_fluoroImages[uuid]->imgToFixture(pt, cursorLine);

        QString fixUuid = m_fluoroImages[uuid]->fixtureUuid();

        Q_EMIT cursorPosition(fixUuid, cursorLine.p1(), cursorLine.p2());
    }
}

void FluoroManager::initialize()
{
    if (m_fluoroImages.contains("LatImage"))
    {
        FluoroImage* latImg = m_fluoroImages["LatImage"];
        m_bodyPosterior_latImg = latImg->fixtureToImg(QVector3D(-20, 0, 0));
        m_bodyAnterior_latImg = latImg->fixtureToImg(QVector3D(20, 0, 0));
    }

    if (m_fluoroImages.contains("LatImage"))
    {
        FluoroImage* apImg = m_fluoroImages["LatImage"];
        m_pedicleAinside_apImg = apImg->fixtureToImg(QVector3D(20, 0, 0));
        m_pedicleBinside_apImg = apImg->fixtureToImg(QVector3D(-20, 0, 0));
    }
    Q_EMIT pointsChanged();
}


QVector3D FluoroManager::closestPointOnLineAfromLineB(QVector3D lineAp0,
                                                      QVector3D lineAp1,
                                                      QVector3D lineBp0,
                                                      QVector3D lineBp1)
{
    GmLine lA;
    lA.setLine(lineAp0, lineAp1);

    GmLine lB;
    lB.setLine(lineBp0, lineBp1);

    return GmLine::closestPointOnLineAfromLineB(lA, lB);
}

void FluoroManager::autoScrewPlacement()
{
    if (m_fluoroImages.contains("APImage") &&
        m_fluoroImages.contains("LatImage"))
    {
        GmLine pAi;
        GmLine pBi;
        m_fluoroImages["APImage"]->imgToFixture(m_pedicleAinside_apImg, pAi);
        m_fluoroImages["APImage"]->imgToFixture(m_pedicleBinside_apImg, pBi);

        GmLine bP;
        GmLine bA;

        m_fluoroImages["LatImage"]->imgToFixture(m_bodyPosterior_latImg, bP);
        m_fluoroImages["LatImage"]->imgToFixture(m_bodyAnterior_latImg, bA);

        m_pHead_A = GmLine::closestPointOnLineAfromLineB(pAi, bP);
        m_pTip_A = GmLine::closestPointOnLineAfromLineB(bA, pAi);

        QVector3D screwAdir = pAi.dir();
        m_pHead_A += screwAdir * 30;
        m_pTip_A += screwAdir * 20;


        m_pHead_B = GmLine::closestPointOnLineAfromLineB(pBi, bP);
        m_pTip_B = GmLine::closestPointOnLineAfromLineB(bA, pBi);

        QVector3D screwBdir = pBi.dir();
        m_pHead_B += screwBdir * 30;
        m_pTip_B += screwBdir * 20;


        Q_EMIT pointsChanged();
    }
}

void FluoroManager::update()
{
    Q_EMIT pointsChanged();
}

void FluoroManager::computeRegistration()
{
    GmLine pAi, pBi;

    m_fluoroImages["APImage"]->imgToFixture(m_pedicleAinside_apImg, pAi);
    m_fluoroImages["APImage"]->imgToFixture(m_pedicleBinside_apImg, pBi);

    GmLine bP, bA;
    m_fluoroImages["LatImage"]->imgToFixture(m_bodyPosterior_latImg, bP);
    m_fluoroImages["LatImage"]->imgToFixture(m_bodyAnterior_latImg, bA);

    QVector3D pAOnBp = GmLine::closestPointOnLineAfromLineB(bP, pAi);
    QVector3D pBOnBp = GmLine::closestPointOnLineAfromLineB(bP, pBi);
    QVector3D bodyPosterior = (pAOnBp + pBOnBp) / 2.0;

    QVector3D pAOnBa = GmLine::closestPointOnLineAfromLineB(bA, pAi);
    QVector3D pBOnBa = GmLine::closestPointOnLineAfromLineB(bA, pBi);
    QVector3D bodyAnterior = (pAOnBa + pBOnBa) / 2.0;

    QVector3D pWa = GmLine::closestPointOnLineAfromLineB(pAi, bP);
    QVector3D pWb = GmLine::closestPointOnLineAfromLineB(pBi, bP);

    float apMMPerPix =
        (pWb - pWa).length() /
        (m_pedicleBinside_apImg - m_pedicleAinside_apImg).length();

    QVector3D apDir = (pWb - pWa).normalized();

    m_RegPnts.clear();
    m_RegPnts += bodyAnterior;
    m_RegPnts += bodyPosterior;

    m_RegPnts += pWa - apDir * (m_pedicleAwidth_apImg * apMMPerPix);
    m_RegPnts += pWa;
    m_RegPnts += (pWa + pWb) / 2.0;
    m_RegPnts += pWb;
    m_RegPnts += pWb + apDir * (m_pedicleBwidth_apImg * apMMPerPix);

    qDebug() << m_pedicleAinside_apImg << m_pedicleAwidth_apImg
             << m_pedicleBinside_apImg << m_pedicleBwidth_apImg;
    qDebug() << m_bodyAnterior_latImg << m_bodyPosterior_latImg;

    Q_EMIT registrationChanged(m_RegPnts);
}
