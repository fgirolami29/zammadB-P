// Copyright (C) 2012-2024 Zammad Foundation, https://zammad-foundation.org/

import type { FormFieldContext } from '#shared/components/Form/types/field.ts'
import type { SelectValue } from '#shared/components/CommonSelect/types.ts'
import type { TreeSelectOption } from '#shared/components/Form/fields/FieldTreeSelect/types.ts'

export enum GroupAccess {
  Read = 'read',
  Create = 'create',
  Change = 'change',
  Overview = 'overview',
  Full = 'full',
}

export type GroupPermissionsContext = FormFieldContext<{
  options: TreeSelectOption[]
}>

export interface GroupPermissionReactive {
  groups: SelectValue
  groupAccess: Record<GroupAccess, boolean>
}
