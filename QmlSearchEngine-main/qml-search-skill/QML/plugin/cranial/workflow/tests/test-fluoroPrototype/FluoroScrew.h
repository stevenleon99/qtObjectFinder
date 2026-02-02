#ifndef FLUOROSCREW_H
#define FLUOROSCREW_H

#include <QObject>
#include <tracking/TransformationObject.h>

class FluoroScrew : public QObject
{
    Q_OBJECT

    Q_PROPERTY(QVector3D tip READ tip WRITE setTip NOTIFY tipChanged)
    Q_PROPERTY(QVector3D head READ head WRITE setHead NOTIFY headChanged)

public:
    explicit FluoroScrew(QObject *parent = 0);
    ~FluoroScrew();

    QVector3D tip() const { return m_tip; }
    QVector3D head() const { return m_head; }

signals:
    void tipChanged(QVector3D arg);
    void headChanged(QVector3D arg);

public slots:
    void setTip(QVector3D arg);
    void setHead(QVector3D arg);

private:
    QVector3D m_tip;
    QVector3D m_head;

    QString m_referenceSpace;
    TransformationObject::CoordinateSystems m_referenceSystem;
};

#endif // FLUOROSCREW_H
