#ifndef TestManipulator_H
#define TestManipulator_H

#include <QObject>
#include <QVector2D>
#include <QSizeF>
#include <QVariant>

class TestManipulator : public QObject
{
    Q_OBJECT

public:
    explicit TestManipulator(QObject* parent = 0);

signals:

public slots:
    void rotation(const QVector2D& lastPos,
                  const QVector2D& currentPos,
                  QVariant camera);
    void followFingers(const QVector2D& lastP1,
                       const QVector2D& lastP2,
                       const QVector2D& currentP1,
                       const QVector2D& currentP2,
                       QVariant camera);
    void setViewSize(QVariant camera, QSizeF sz);

private:
};

#endif  // TestManipulator_H
