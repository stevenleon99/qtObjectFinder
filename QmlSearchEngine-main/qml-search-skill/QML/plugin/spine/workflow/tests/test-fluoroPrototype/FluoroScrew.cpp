#include "FluoroScrew.h"

FluoroScrew::FluoroScrew(QObject* parent)
    : QObject(parent)
{}

FluoroScrew::~FluoroScrew() {}

void FluoroScrew::setTip(QVector3D arg)
{
    if (m_tip == arg)
        return;

    m_tip = arg;
    emit tipChanged(arg);
}

void FluoroScrew::setHead(QVector3D arg)
{
    if (m_head == arg)
        return;

    m_head = arg;
    emit headChanged(arg);
}
