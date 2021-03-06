${group_name}
${len(group_name) * '='}

.. list-table:: Успеваемость (`${course.name} <https://lectureswww.readthedocs.io/>`_)
   :header-rows: 1
   :stub-columns: 1

   ## Header
   * -
     - ФИО \
     <%block name="checkpoints_header">
     % for _, values in course.checkpoints_group:
     - `${values.get('name', '')} <${quote(values.get("url", "./"))}>`__
     %endfor
     </%block>

   ## Deadline
   * -
     -
     % for _, values in course.checkpoints_group:
     - <% date = values.get("date") %> \
       %if date:
         ${date.split('/')[0]}/${date.split('/')[1]} ${date.split('/')[2]}
       %else:

       %endif
     %endfor

     ## Students
     <%
       qty = len(students)
       _len = len(course.checkpoints_group)
       meanScore = [0] * _len
       meanProgress = [0] * _len
     %> \
     % for obj in students:

   * - ${loop.index+1}
     - ${obj.name} \
     %if obj.github:
       (`${obj.github} <https://github.com/${quote(obj.github)}>`_)
     %else:

     %endif
     %for _checkpoint in obj.checkpoints(course):
     - \
       <%
         checkpoint_loop = loop
       %> \
       %for key, value in _checkpoint.items():
         %if key is not 'score':
           %if isinstance(value, collections.MutableSequence) :
             %for _item in value:
               `${key}.${loop.index+1} <${quote(_item)}>`__ \
             %endfor
           %else:
             `${key} <${quote(value)}>`__ \
           %endif
         %endif
         %if loop.last:
           <%
             score = _checkpoint.get('score', '')
           %> \
           %if score:
             [**+${score}**]
             <%
               meanScore[checkpoint_loop.index] += score
               meanProgress[checkpoint_loop.index] += 1
             %>
           %else:
             ${''}
           %endif
         %endif
       %endfor
     %endfor

     %endfor

Статистика
----------

.. list-table::
   :header-rows: 1
   :stub-columns: 1

   ## Header
   * - \
     ${checkpoints_header()} \

   ## Mean progress in percent
   * - % сдачи
   %for item in meanProgress:
     - ${round(item / (qty / 100), 2)}
   %endfor

   ## Mean score
   * - средний балл группы
   %for item in meanScore:
     - ${round(item / qty, 2)}
   %endfor

   ## Mean score
   * - средний балл сдачи
   %for item in meanScore:
     <%
       scoreQty = meanProgress[loop.index]
       scoreQty = scoreQty if scoreQty > 0 else scoreQty + 1
     %>
     - ${round(item / scoreQty, 2)}
   %endfor

   ## Level
   * - сложность задания (от 0 до 5)
   %for item in meanScore:
     <%
       scoreQty = meanProgress[loop.index]
       scoreQty = scoreQty if scoreQty > 0 else scoreQty + 1
       _meanScore = round(item / scoreQty, 2)
     %>
     - ${round(5 - 5 * math.fabs(2*_meanScore/100 - 1)**0.5)}
   %endfor

   ## Profit
   * - Продуктивность группы в %
   %for item in meanScore:
     <%
       scoreQty = meanProgress[loop.index]
       scoreQty = scoreQty if scoreQty > 0 else scoreQty + 1
       _meanScore = round(item / scoreQty, 2)
       _meanProgress = item / qty
     %>
     - ${round(_meanProgress * math.fabs(2*_meanScore/100 - 1)**0.5, 2)}
   %endfor
