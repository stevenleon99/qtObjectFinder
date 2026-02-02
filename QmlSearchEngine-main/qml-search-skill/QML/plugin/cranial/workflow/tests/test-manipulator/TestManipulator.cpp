#include "TestManipulator.h"
#include <QGLCamera>
#include <QMatrix4x4>
#include <QQuickItem>
#include <QtDebug>
#include <qmath.h>
#include <algorithms/GmVectorUtils.h>

TestManipulator::TestManipulator(QObject *parent) :
    QObject(parent)
{
}

void TestManipulator::setViewSize(QVariant varCamera,QSizeF sz)
{
    QGLCamera *camera = qobject_cast<QGLCamera *>(varCamera.value< QObject* >());
    if(!camera)
    {
        qDebug() << "TestManipulator::setViewSize - Bad Parent";
        return;
    }

    camera->setViewSize(sz);
}

void TestManipulator::followFingers(const QVector2D &lastP1, const QVector2D &lastP2, const QVector2D &currentP1, const QVector2D &currentP2, QVariant varCamera)
{
    QQuickItem  *parentItem = qobject_cast<QQuickItem  *>(parent());
    QGLCamera *camera = qobject_cast<QGLCamera *>(varCamera.value< QObject* >());

    if(!parentItem && !camera)
    {
        qDebug() << "TestManipulator::followFingers - Bad Parent";
        return;
    }

    QVector2D dirLast = lastP2 - lastP1;
    QVector2D dirCurrent = currentP2 - currentP1;

    QSizeF zoomCurrent = dirLast.length() / dirCurrent.length() * camera->viewSize();

    const double shiftAngle = GmVectorUtils::angleRad(dirLast, dirCurrent);

    QVector3D viewDir = (camera->center() - camera->eye()).normalized();

    QVector2D mouseCenterLast = QVector2D(parentItem->width(),parentItem->height()) / 2.0 - lastP1;

    QVector3D screenXlast = QVector3D::normal(viewDir, camera->upVector().normalized()) * mouseCenterLast.x() * camera->viewSize().width() /parentItem->width();
    QVector3D screenYlast = camera->upVector().normalized() * mouseCenterLast.y()* camera->viewSize().height() /parentItem->height();

    QVector3D fP1a = camera->center() - screenXlast + screenYlast;

    QVector2D mouseCenterCurrent = QVector2D(parentItem->width(),parentItem->height()) / 2.0 - currentP1;

    QMatrix4x4 mat;
    mat.rotate(-shiftAngle*180.0/M_PI,viewDir);
    camera->setUpVector((mat * camera->upVector()).normalized());
    camera->setViewSize(zoomCurrent);

    QVector3D screenXcurrent = QVector3D::normal(viewDir, camera->upVector().normalized()) * mouseCenterCurrent.x()* camera->viewSize().width() /parentItem->width();
    QVector3D screenYcurrent = camera->upVector().normalized() * mouseCenterCurrent.y()* camera->viewSize().height() /parentItem->height();

    QVector3D center = fP1a + screenXcurrent - screenYcurrent;
    QVector3D delta = center - camera->center();

    camera->setCenter(center);
    camera->setEye(camera->eye() + delta);
}

void TestManipulator::rotation(const QVector2D &lastPos, const QVector2D &pos, QVariant varCamera)
{
    QQuickItem  *parentItem = qobject_cast<QQuickItem  *>(parent());
    QGLCamera *camera = qobject_cast<QGLCamera *>(varCamera.value< QObject* >());

    if(!parentItem && !camera)
    {
        qDebug() << "TestManipulator::transformAtoB - Bad Parent";
        return;
    }

    QVector2D delta = pos - lastPos;

    float anglex = delta.x() * 90.0f / parentItem->width();
    float angley = delta.y() * 90.0f / parentItem->height();
    QQuaternion q = camera->pan(-anglex);
    q *= camera->tilt(-angley);
    camera->rotateCenter(q);

}
